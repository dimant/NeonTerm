namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Threading;

    class NeonReader
    {
        private readonly CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();

        public CancellationToken CancellationToken => cancellationTokenSource.Token;

        private ILineReader lineReader;

        private ConcurrentQueue<string> lines = new ConcurrentQueue<string>();

        public NeonReader(ILineReader lineReader)
        {
            this.lineReader = lineReader ?? throw new ArgumentNullException(nameof(lineReader));
        }

        public bool MatchesError(string line)
        {
            return line.Contains("Unknown token:");
        }

        public string ReadLine()
        {
            string line;
            var success = lines.TryDequeue(out line);
            if (success)
            {
                if (this.MatchesError(line))
                {
                    this.cancellationTokenSource.Cancel();
                    return string.Empty;
                }

                return line;
            }
            else
            {
                return string.Empty;
            }
        }

        public void Start()
        {
            while(false == this.CancellationToken.IsCancellationRequested)
            {
                this.lines.Enqueue(lineReader.ReadLine());
            }
        }
    }
}
