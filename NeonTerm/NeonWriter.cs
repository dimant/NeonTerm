namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Threading;

    class NeonWriter
    {
        private ILineWriter lineWriter;

        private ConcurrentQueue<string> lines = new ConcurrentQueue<string>();

        public NeonWriter(ILineWriter lineWriter)
        {
            this.lineWriter = lineWriter ?? throw new ArgumentNullException(nameof(lineWriter));
        }

        public void WriteLine(string line)
        {
            lines.Enqueue(line);
        }

        public void Start(CancellationToken cancellationToken)
        {
            while(!cancellationToken.IsCancellationRequested)
            {
                string line;
                var success = lines.TryDequeue(out line);
                if (success)
                {
                    this.lineWriter.WriteLine(line);
                }
            }

            lines.Clear();
        }
    }
}
