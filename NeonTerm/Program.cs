namespace NeonTerm
{
    using Microsoft.Extensions.CommandLineUtils;
    using System;
    using System.IO.Ports;
    using System.Linq;
    using System.Text;
    using System.Threading;
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
                    var portName = portOption.Value().ToUpper();
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

            commandLineApplication.Execute(args);
        }

        public static int StartTerminalLoop(string portName)
        {
            using (var neonSerial = new NeonSerial(portName))
            {
                neonSerial.Open();

                var neonReader = new NeonReader(neonSerial);
                var neonWriter = new NeonWriter(neonSerial);

                var cancellationToken = neonReader.CancellationToken;

                var readTask = Task.Factory.StartNew(() => neonReader.Start());
                var writeTask = Task.Factory.StartNew(() => 
                {
                    while(false == cancellationToken.IsCancellationRequested)
                    {
                        if (Console.KeyAvailable)
                        {
                            var keyInfo = Console.ReadKey(intercept: true);
                            var c = keyInfo.KeyChar;
                            neonWriter.WriteChar(c, cancellationToken);
                        }
                        else
                        {
                            Task.Delay(10, cancellationToken);
                        }
                    }
                });

                neonReader.OnCharAvailable = (c) =>
                {
                    Console.Out.Write(c);
                };

                Task.WaitAll(readTask, writeTask);
            }

            return 1;
        }

        public static bool ValidatePortName(string portName)
        {
            var portNames = SerialPort.GetPortNames();

            if(false == portNames.Contains(portName))
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
