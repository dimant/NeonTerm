namespace NeonTerm
{
    using Microsoft.Extensions.CommandLineUtils;
    using System;
    using System.IO.Ports;
    using System.Threading.Tasks;
    
    class Program
    {
        static void Main(string[] args)
        {
            /// command line parsing: https://docs.microsoft.com/en-us/archive/msdn-magazine/2016/september/essential-net-command-line-processing-with-net-core-1-0

            var commandLineApplication = new CommandLineApplication(throwOnUnexpectedArg: false);

            var portOption = commandLineApplication.Option(
                "-p|--port",
                "The serial port to which the Neon816 is connected.",
                CommandOptionType.SingleValue
                );

            commandLineApplication.HelpOption("-?|-h|--help");

            commandLineApplication.OnExecute(() =>
            {
                if (portOption.HasValue())
                {
                    var portName = portOption.Value();
                    if (false == ValidatePortName(portName))
                    {
                        return 1;
                    }
                    else
                    {
                        return StartTerminalLoop(portName);
                    }
                }
                else
                {
                    commandLineApplication.ShowHelp();
                    return 1;
                }
            });
        }

        public static int StartTerminalLoop(string portName)
        {
            using (var neonSerial = new NeonSerial(portName))
            {
                var neonReader = new NeonReader(neonSerial);
                var neonWriter = new NeonWriter(neonSerial);

                var cancellationToken = neonReader.CancellationToken;

                var readTask = Task.Factory.StartNew(() => neonReader.Start());
                var writeTask = Task.Factory.StartNew(() => neonWriter.Start(cancellationToken));
                
                neonReader.OnLineAvailable = () => 
                    Console.Out.WriteLine(neonReader.ReadLine());

                var consoleReaderTask = Task.Factory.StartNew(() =>
                {

                    while (false == cancellationToken.IsCancellationRequested)
                    {
                        var line = Console.In.ReadLine();
                        neonWriter.WriteLine(line);
                    }
                });

                Task.WaitAll(readTask, writeTask, consoleReaderTask);
            }

            return 1;
        }

        public static bool ValidatePortName(string portName)
        {
            var portNames = SerialPort.GetPortNames();

            if(false == portName.Contains(portName))
            {
                Console.Out.WriteLine($"Port {portName} is not available. Available ports:");

                foreach(var pN in portNames)
                {
                    Console.Out.WriteLine(portName);
                }

                return false;
            }

            return true;
        }
    }
}
