namespace NeonTerm
{
    class FilterCR : IFilter
    {
        public bool Filter(char c)
        {
            if('\r' == c)
            {
                return true;
            }

            return false;
        }

        public void Reset()
        {
        }
    }
}
