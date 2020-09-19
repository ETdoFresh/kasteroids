using System;
using System.Collections.Generic;
using System.Linq;

public static class DictionaryExtension
{
    public static Dictionary<T0, T1> Merge<T0, T1>(this Dictionary<T0, T1> destination, Dictionary<T0, T1> source)
    {
        var result = new Dictionary<T0, T1>(destination);
        foreach (var key in source.Keys)
            result[key] = source[key];
        return result;
    }

    public static Dictionary<T0, T1> Duplicate<T0, T1>(this Dictionary<T0, T1> dictionary)
        => new Dictionary<T0, T1>(dictionary);
}