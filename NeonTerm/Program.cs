using System;
using System.IO.Ports;
using System.Threading.Tasks;

namespace NeonTerm
{
    class Program
    {
        static void Main(string[] args)
        {
            /// command line parsing: https://docs.microsoft.com/en-us/archive/msdn-magazine/2016/september/essential-net-command-line-processing-with-net-core-1-0

            PrintPortNames();

            var neonSerial = new NeonSerial("com1");
            var neonReader = new NeonReader(neonSerial);
            var neonWriter = new NeonWriter(neonSerial);

            var cancellationToken = neonReader.CancellationToken;

            var readTask = Task.Factory.StartNew(() => neonReader.Start());
            var writeTask = Task.Factory.StartNew(() => neonWriter.Start(cancellationToken));

            Task.WaitAll(readTask, writeTask);

            while(false == cancellationToken.IsCancellationRequested)
            {
                var line = Console.In.ReadLine();
                neonWriter.WriteLine(line);
            }
        }

        public static void PrintPortNames()
        {
            var portNames = SerialPort.GetPortNames();


            Console.Out.WriteLine("Available ports:");

            foreach(var portName in portNames)
            {
                Console.Out.WriteLine(portName);
            }
        }
    }
}
