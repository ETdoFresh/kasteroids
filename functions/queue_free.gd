class_name QueueFreeFunctions

static func is_queue_free(_key, object: Dictionary) -> bool:
    return "queue_free" in object and object.queue_free
