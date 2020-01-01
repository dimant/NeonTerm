namespace NeonTerm
{
    public class FilterComment : IFilter
    {
        private char maybeComment = '\0';

        private char inComment = '\0';

        public void Reset()
        {
            maybeComment = '\0';
            inComment = '\0';
        }

        public bool Filter(char c)
        {
            if ('(' == inComment)
            {
                if (')' == c)
                {
                    inComment = '\0';
                    return false;
                }
                else if ('\n' == c)
                {
                    inComment = '\0';
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else if ('\\' == inComment)
            {
                if ('\n' == c)
                {
                    inComment = '\0';
                    return false;
                }
                else
                {
                    return true;
                }
            }

            if ('\0' != maybeComment)
            {
                if (' ' == c)
                { 
                    inComment = maybeComment;
                }

                maybeComment = '\0';
            }

            if ('(' == c || '\\' == c)
            {
                maybeComment = c;
            }

            return false;
        }
    }
}
