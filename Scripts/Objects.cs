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

    public static IEnumerable<T1> PerObject<T0, T1>(this IEnumerable<T0> objects, Func<T0, T1> func)
        => objects.Select(func);
}