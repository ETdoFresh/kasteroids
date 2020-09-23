using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Array = Godot.Collections.Array;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;
using Object = Godot.Object;

public static class GodotExtensions
{
    public static object[] EMPTY_ARG = new object[0];

    public static IObjects AddObjectsFromScene(this IObjects objects, Array children)
    {
        return objects
            .Concat(children
                .Cast<Node>()
                .Select(CreateDataObjectFromNode));
    }

    public static IObjects UpdateSprites(this IObjects objects)
    {
        return objects
            .RemoveNode2DObjects()
            .Concat(objects
                .GetSprites()
                .Select(UpdateSprite)); // Side-effect
    }

    public static DataObject CreateDataObjectFromNode(Node node)
    {
        // if (node is ShipNode shipNode)
        //     return shipNode.ship;
        
        var dataObject = new DataObject();
        // dataObject.node = node;
        // dataObject.name = node.Name;
        // var toDataObject = node.GetType().GetMethod("ToDataObject");
        // if (toDataObject != null)
        // {
        //     dataObject = (DataObject)toDataObject.Invoke(node, EMPTY_ARG);
        // }
        // else if (node is Node2D node2D)
        // {
        //     dataObject.position = node2D.GlobalPosition;
        //     dataObject.rotation = node2D.GlobalRotation;
        //     dataObject.scale = node2D.GlobalScale;
        // }
        return dataObject;
    }

    public static IObjects RemoveNode2DObjects(this IObjects objects)
        => objects.Where(o => !(o.node is Node2D));

    public static IEnumerable<Tuple<DataObject, Node2D>> GetSprites(this IEnumerable<DataObject> objects)
        => objects
            .Where(o => o.node is Node2D)
            .Select(o => new Tuple<DataObject, Node2D>(o, (Node2D)o.node))
            .Cast<Tuple<DataObject, Node2D>>();

    public static DataObject UpdateSprite(Tuple<DataObject, Node2D> objectNode2DTuple)
    {
        var obj = objectNode2DTuple.Item1;
        var node = objectNode2DTuple.Item2;
        node.GlobalPosition = obj.position;
        node.GlobalRotation = obj.rotation;
        node.GlobalScale = obj.scale;
        return obj;
    }

    public static T Get<T>(this Object godotObject, string property)
    {
        return (T)godotObject.Get(property);
    }
}
