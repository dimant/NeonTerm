namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Threading;

    class NeonReader
    {
        private readonly CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();

        public CancellationTokenSource CancellationTokenSource => cancellationTokenSource;

        private ILineReader lineReader;

        private ConcurrentQueue<string> lines = new ConcurrentQueue<string>();

        public NeonReader(ILineReader lineReader)
        {
            this.lineReader = lineReader ?? throw new ArgumentNullException(nameof(lineReader));
        }

        public bool MatchesError(string line)
        {
            return false;
        }

        public string ReadLine()
        {
            string line;
            var success = lines.TryDequeue(out line);
            if (success)
            {
                if (this.MatchesError(line))
                {
                    CancellationTokenSource.Cancel();
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
            while(false == cancellationTokenSource.Token.IsCancellationRequested)
            {
                this.lines.Enqueue(lineReader.ReadLine());
            }
        }
    }
}
