public class InputNode : FSharp.InputNode { }

public class InputData : DataObject
{
    public float horizontal = 0;
    public float vertical = 0;
    public bool fire = false;

    public void GetValues()
    {
        horizontal = node.Get<float>("horizontal");
        vertical = node.Get<float>("vertical");
        fire = node.Get<bool>("fire");
    }
}