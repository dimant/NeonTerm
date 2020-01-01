namespace NeonTerm
{
    using System;
    using System.Text;
    using System.Threading;

    class NeonReader
    {
        private readonly CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();

        private ICharReader charReader;

        private StringBuilder lineBuilder = new StringBuilder();

        public CancellationToken CancellationToken => cancellationTokenSource.Token;

        public Action<char> OnCharAvailable { get; set; }

        public NeonReader(ICharReader charReader)
        {
            this.charReader = charReader ?? throw new ArgumentNullException(nameof(charReader));
        }

        public bool MatchesError(string line)
        {
            return line.Contains("Unknown Token:");
        }

        public void Cancel()
        {
            this.cancellationTokenSource.Cancel();
        }

        public void Start()
        {
            while(false == this.CancellationToken.IsCancellationRequested)
            {
                var c = this.charReader.ReadChar();
                if(null != c)
                {
                    lineBuilder.Append(c);
                    this.OnCharAvailable?.Invoke(c.Value);

                    if(c == '\n')
                    {
                        var line = this.lineBuilder.ToString();
                        if (this.MatchesError(line))
                        {
                            Console.Error.WriteLine($"NeonTerm: {line}");

                            this.cancellationTokenSource.Cancel();
                        }
                    }
                }
            }
        }
    }
}
