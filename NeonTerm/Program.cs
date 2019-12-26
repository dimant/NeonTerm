namespace NeonTerm
{
    using Microsoft.Extensions.CommandLineUtils;
    using System;
    using System.IO.Ports;
    using System.Linq;
    using System.Threading.Tasks;

    class Program
    {
        static void Main(string[] args)
        {
            /// command line parsing: https://docs.microsoft.com/en-us/archive/msdn-magazine/2016/september/essential-net-command-line-processing-with-net-core-1-0

            var app = new CommandLineApplication(throwOnUnexpectedArg: false);

            var portOption = app.Option(
                "-p|--port",
                "The serial port to which the Neon816 is connected.",
                CommandOptionType.SingleValue
                );

            var debugOption = app.Option(
                "-d|--debug",
                "Debug over 3.3V UART connection.",
                CommandOptionType.NoValue);

            app.HelpOption("-?|-h|--help");

            app.OnExecute(() =>
            {
                if (portOption.HasValue())
                {
                    var portName = portOption.Value().ToUpper();
                    if (false == ValidatePortName(portName))
                    {
                        return 1;
                    }

                    if (debugOption.HasValue())
                    {
                        return StartDebugLoop(portName);
                    }
                    else
                    {
                        return StartForthLoop(portName);
                    }
                }
                else
                {
                    app.ShowHelp();
                    return 1;
                }
            });

            app.Execute(args);
        }

        public static int StartDebugLoop(string portName)
        {
            using (var neonSerial = new NeonSerial(portName, NeonSerial.Profile.Debug))
            {
                neonSerial.Open();

                neonSerial.WriteChar(']');
                neonSerial.WriteChar('R');
                neonSerial.WriteChar('[');
            }
            return 0;
        }

        public static int StartForthLoop(string portName)
        {
            using (var neonSerial = new NeonSerial(portName, NeonSerial.Profile.Forth))
            {
                neonSerial.Open();

                var neonReader = new NeonReader(neonSerial);
                var neonWriter = new NeonWriter(neonSerial);

                var cancellationToken = neonReader.CancellationToken;

                var readTask = Task.Factory.StartNew(() => neonReader.Start());
                var writeTask = Task.Factory.StartNew(() => neonWriter.Start(cancellationToken));
                var consoleWriteTask = Task.Factory.StartNew(() =>
                {
                    while (false == cancellationToken.IsCancellationRequested)
                    {
                        if (Console.KeyAvailable)
                        {
                            var keyInfo = Console.ReadKey(intercept: true);
                            var c = keyInfo.KeyChar;

                            if (c == '\r')
                            {
                                c = '\n';
                            }

                            neonWriter.WriteChar(c);
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

                Task.WaitAll(readTask, writeTask, consoleWriteTask);
            }

            return 1;
        }

        public static bool ValidatePortName(string portName)
        {
            var portNames = SerialPort.GetPortNames();

            if (false == portNames.Contains(portName))
            {
                Console.Out.WriteLine($"Port {portName} is not available. Available ports:");

                foreach (var pN in portNames)
                {
                    Console.Out.WriteLine(pN);
                }

                return false;
            }

            return true;
        }
    }
}
