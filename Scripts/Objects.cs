using System.Collections.Generic;
using System.Linq;
using IObjects = System.Collections.Generic.IEnumerable<DataObject>;


public static class ObjectsFunctions
{
    public static IObjects Remove<T>(this IObjects objects) where T : DataObject
        => objects.Where(o => !(o is T));
    
    public static IEnumerable<T> Get<T>(this IObjects objects) where T : DataObject
        => objects.Where(o => (o is T)).Cast<T>();
}