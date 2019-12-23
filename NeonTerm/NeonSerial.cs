namespace NeonTerm
{
    using System;
    using System.IO.Ports;
    using System.Linq;
    using System.Threading;

    class NeonSerial : ILineWriter, ILineReader, IDisposable
    {
        private const int msPerLine = 150;
        
        private readonly SerialPort serialPort;

        private bool disposed = false;

        public NeonSerial(string port)
        {
            if(string.IsNullOrEmpty(port))
            {
                throw new ArgumentNullException(nameof(port));
            }

            if(false == this.IsValidPort(port))
            {
                throw new ArgumentOutOfRangeException(nameof(port));
            }

            // the port settings are Neon specific
            this.serialPort = new SerialPort(port, 9600, Parity.None, 8, StopBits.None);
            this.serialPort.ReadTimeout = 250; // ms
            this.serialPort.WriteTimeout = 500; //ms
        }

        public void Dispose()
        {
            // Dispose of unmanaged resources.
            Dispose(isDisposing: true);
            // Suppress finalization.
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool isDisposing)
        {
            if (this.disposed)
            {
                return;
            }

            if (isDisposing)
            {
                this.serialPort.Dispose();
            }

            this.disposed = true;
        }

        public bool IsValidPort(string port)
        {
            var ports = SerialPort.GetPortNames();
            return ports.Contains(port);
        }

        public string ReadLine()
        {
            try
            {
                string line = this.serialPort.ReadLine();
                return line;
            }
            catch (TimeoutException)
            {
                return string.Empty;
            }
        }

        public void WriteLine(string line)
        {
            this.serialPort.WriteLine(line);
            Thread.Sleep(msPerLine);
        }
    }
}
