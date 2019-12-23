using Microsoft.Extensions.CommandLineUtils;
using System;
using System.IO.Ports;

namespace NeonTerm
{
    class Program
    {
        static void Main(string[] args)
        {
            /// command line parsing: https://docs.microsoft.com/en-us/archive/msdn-magazine/2016/september/essential-net-command-line-processing-with-net-core-1-0

            PrintPortNames();

            var serialPort = new SerialPort("com1", 9600, Parity.None, 8, StopBits.One);
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
