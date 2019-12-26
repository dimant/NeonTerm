namespace NeonTerm
{
    using System;
    using System.IO.Ports;
    using System.Linq;
    using System.Threading;

    class NeonSerial : ICharWriter, ICharReader, IDisposable
    {
        public enum Profile
        {
            Forth,
            Debug
        };

        private readonly SerialPort serialPort;

        private bool disposed = false;

        public NeonSerial(string port, Profile profile)
        {
            if (string.IsNullOrEmpty(port))
            {
                throw new ArgumentNullException(nameof(port));
            }

            if (false == this.IsValidPort(port))
            {
                throw new ArgumentOutOfRangeException(nameof(port));
            }

            int speed = 0;

            switch (profile)
            {
                case Profile.Forth:
                    speed = 9600;
                    break;
                case Profile.Debug:
                    speed = 57600;
                    break;
            }

            // the port settings are Neon specific
            this.serialPort = new SerialPort(port, speed, Parity.None, 8, StopBits.One);
            this.serialPort.ReadTimeout = 250; // ms
            this.serialPort.WriteTimeout = 500; //ms
        }

        public void Open()
        {
            this.serialPort.Open();
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

        public char? ReadChar()
        {
            try
            {
                int i = this.serialPort.ReadChar();
                char c = Convert.ToChar(i);
                return c;
            }
            catch (TimeoutException)
            {
                return null;
            }
        }

        public void WriteChar(char c)
        {
            byte b = Convert.ToByte(c);
            this.serialPort.Write(new byte[] { b }, 0, 1);
        }
    }
}
