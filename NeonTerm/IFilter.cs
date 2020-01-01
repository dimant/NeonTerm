namespace NeonTerm
{
    public interface IFilter
    {
        bool Filter(char c);
        void Reset();
    }
}