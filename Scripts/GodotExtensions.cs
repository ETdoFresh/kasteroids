using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Array = Godot.Collections.Array;

public static class GodotExtensions
{
    public static object[] EMPTY_ARG = new object[0];

    public static State AddObjectsFromScene(this State state, Array objects)
    {
        return state.UpdateObjects(state.objects
            .Cast<Node>()
            .Select(ToDataObject));
    }

    public static State UpdateSprites(this State state)
    {
        return state.UpdateObjects(state.objects
            .RemoveAsteroids()
            .Concat(state.objects
                .GetAsteroids()
                .GetSprites()
                .Select(UpdateSprite))); // Side-effect
    }

    public static DataObject ToDataObject(Node node)
    {
        var dataObject = new DataObject();
        dataObject.node = node;
        dataObject.name = node.Name;
        var toDataObject = node.GetType().GetMethod("ToDataObject");
        if (toDataObject != null)
        {
            dataObject = (DataObject)toDataObject.Invoke(node, EMPTY_ARG);
        }
        else if (node is Node2D node2D)
        {
            dataObject.position = node2D.GlobalPosition;
            dataObject.rotation = node2D.GlobalRotation;
            dataObject.scale = node2D.GlobalScale;
        }
        return dataObject;
    }

    public static IEnumerable<Tuple<DataObject, Sprite>> GetSprites(this IEnumerable<DataObject> objects)
        => objects
            .Where(o => o.node.Get("Sprite") != null)
            .Select(o => new Tuple<DataObject, object>(o, o.node.Get("Sprite")))
            .Cast<Tuple<DataObject, Sprite>>();

    public static DataObject UpdateSprite(Tuple<DataObject, Sprite> objectSpriteTuple)
    {
        var obj = objectSpriteTuple.Item1;
        var sprite = objectSpriteTuple.Item2;
        sprite.GlobalScale = obj.scale;
        return obj;
    }
}
