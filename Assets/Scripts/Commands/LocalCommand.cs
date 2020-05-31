namespace Commands {
    public abstract class LocalCommand : Command
    {
        public virtual void Send(params object[] args) { }
    }
}