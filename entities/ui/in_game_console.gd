class_name InGameConsole
extends Panel

export var max_lines = 100

var lines = []

func write_line(message):
    lines.append(message)
    
    while lines.size() > max_lines:
        lines.pop_front()
    
    var text = ""
    for i in range(lines.size()):
        if i == 0: text = lines[i]
        else: text += "\n" + lines[i]
    
    if not is_inside_tree(): yield(self, "tree_entered")
    $ScrollContainer/VBoxContainer/Label.text = text
    yield(get_tree(), "idle_frame")
    if lines.size() > 12:
        $ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scrollbar().max_value
