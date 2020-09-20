using System;
using System.Collections.Generic;
using System.Linq;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;


public static class ObjectsFunctions
{
    public static IObjects Remove<T>(this IObjects objects) where T : DataObject
        => objects.Where(o => !(o is T));
    
    public static IEnumerable<T> Get<T>(this IObjects objects) where T : DataObject
        => objects.Where(o => (o is T)).Cast<T>();

    public static IObjects ApplyOn<T>(this IObjects objects, Func<T, T> func) where T : DataObject
    {
        return objects
            .Remove<T>()
            .Concat(objects
                .Get<T>()
                .Select(func));
    }
}