namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;

    class NeonWriter
    {
        private readonly TimeSpan msPerChar = TimeSpan.FromMilliseconds(5);

        private readonly ICharWriter charWriter;

        private readonly ConcurrentQueue<char> chars = new ConcurrentQueue<char>();

        private readonly StringBuilder line = new StringBuilder();

        public NeonWriter(ICharWriter lineWriter)
        {
            this.charWriter = lineWriter ?? throw new ArgumentNullException(nameof(lineWriter));
        }

        public void WriteChar(char c)
        {
            chars.Enqueue(c);
        }

        public void Start(CancellationToken cancellationToken)
        {
            while(false == cancellationToken.IsCancellationRequested)
            {
                char c;

                bool success = this.chars.TryDequeue(out c);

                if (success)
                {
                    this.charWriter.WriteChar(c);
                    Task.Delay(msPerChar).Wait();
                }
            }
        }
    }
}
