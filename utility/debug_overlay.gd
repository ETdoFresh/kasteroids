extends CanvasLayer

var stats = []

func add_stat(stat_name, object, stat_reference, is_method):
    stats.append([stat_name, object, stat_reference, is_method])

func _ready():
    add_stat("FPS", Engine, "get_frames_per_second", true)

func _process(_delta):
    var label_text = ""
    
    for stat in stats:
        var value = null
        if stat[1] and weakref(stat[1]).get_ref():
            if stat[3]:
                value = stat[1].call(stat[2])
            else:
                value = stat[1].get(stat[2])
        label_text += str(stat[0], ": ", value)
        label_text += "\n"
        
    $Label.text = label_text
