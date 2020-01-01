namespace NeonTerm
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading;
    using System.Threading.Tasks;

    class NeonWriter
    {
        private TimeSpan msPerChar = TimeSpan.FromMilliseconds(5);

        public int DelayInMs { set { msPerChar = TimeSpan.FromMilliseconds(value); } }

        private readonly ICharWriter charWriter;

        private readonly ConcurrentQueue<char> chars = new ConcurrentQueue<char>();

        private IList<IFilter> filters = new List<IFilter>();

        public NeonWriter(ICharWriter lineWriter)
        {
            this.charWriter = lineWriter ?? throw new ArgumentNullException(nameof(lineWriter));
        }

        public void AddFilter(IFilter filter)
        {
            this.filters.Add(filter);
        }

        public void WriteChar(char c)
        {
            chars.Enqueue(c);
        }

        public void WaitOnQueueDrained(CancellationToken cancellationToken)
        {
            var task = Task.Factory.StartNew(() =>
            {
                while(false == this.chars.IsEmpty)
                {
                    Task.Delay(msPerChar).Wait();
                }
            });

            task.Wait(cancellationToken);
        }

        public void Start(CancellationToken cancellationToken)
        {
            while(false == cancellationToken.IsCancellationRequested)
            {
                char c;

                bool success = this.chars.TryDequeue(out c);

                if (success)
                {
                    bool filtered = this.filters.Any(x => x.Filter(c));

                    if(false == filtered)
                    {
                        this.charWriter.WriteChar(c);
                        Task.Delay(msPerChar).Wait();
                    }
                }
            }
        }
    }
}
