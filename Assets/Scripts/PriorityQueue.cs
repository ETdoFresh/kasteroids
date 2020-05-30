using System;
using System.Collections.Generic;
using JetBrains.Annotations;

public class PriorityQueue<T> : List<T> where T : IComparable
{
    public PriorityQueue() { }
    public PriorityQueue(params T[] collection) : this((IEnumerable<T>)collection) { }
    public PriorityQueue([NotNull] IEnumerable<T> collection) : base(collection) { }

    public T Dequeue()
    {
        var item = this[0];
        RemoveAt(0);
        return item;
    }

    public void Enqueue(T item)
    {
        for (var i = 0; i < Count; i++)
            if (item.CompareTo(this[i]) <= 0)
            {
                Insert(i, item);
                return;
            }

        Add(item);
    }
}