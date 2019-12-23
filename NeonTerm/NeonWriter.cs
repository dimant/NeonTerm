namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Threading;

    class NeonWriter
    {
        private ICharWriter charWriter;

        private ConcurrentQueue<string> lines = new ConcurrentQueue<string>();

        public NeonWriter(ICharWriter charWriter)
        {
            this.charWriter = charWriter ?? throw new ArgumentNullException(nameof(charWriter));
        }

        public void WriteLine(string line)
        {
            lines.Enqueue(line);
        }

        private void SendLine(string line, CancellationToken cancellationToken)
        {
            foreach(var c in line)
            {
                if(cancellationToken.IsCancellationRequested)
                {
                    return;
                }
                else 
                {                 
                    charWriter.WriteChar(c);
                }
            }
        }

        public void Start(CancellationToken cancellationToken)
        {
            while(!cancellationToken.IsCancellationRequested)
            {
                string line;
                var success = lines.TryDequeue(out line);
                if (success)
                {
                    this.SendLine(line, cancellationToken);
                }
            }

            lines.Clear();
        }
    }
}
