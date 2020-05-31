namespace Commands
{
    public abstract class Command
    {
        public string message = "";
        
        public virtual string GetMessage(params object[] args) => "";
    }
}