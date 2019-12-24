namespace NeonTerm
{
    using System;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;

    class NeonWriter
    {
        private readonly TimeSpan msPerLine = TimeSpan.FromMilliseconds(150);

        private ICharWriter charWriter;

        private StringBuilder line = new StringBuilder();

        public NeonWriter(ICharWriter lineWriter)
        {
            this.charWriter = lineWriter ?? throw new ArgumentNullException(nameof(lineWriter));
        }

        public void WriteChar(char c, CancellationToken cancellationToken)
        {
            line.Append(c);
            this.charWriter.WriteChar(c);

            if(true == this.line.ToString().EndsWith(Environment.NewLine))
            {
                line.Clear();
                Task.Delay(msPerLine, cancellationToken);
            }
        }
    }
}
