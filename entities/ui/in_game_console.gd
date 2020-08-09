class_name InGameConsole
extends Panel

export var max_lines = 100

var lines = []

func _ready():
    var _1 = $VBoxContainer/LineEdit.connect("text_entered", self, "submit_line")

func submit_line(line):
    $VBoxContainer/LineEdit.clear()
    write_line(line)

func write_line(message):
    lines.append(message)
    
    while lines.size() > max_lines:
        lines.pop_front()
    
    var text = ""
    for i in range(lines.size()):
        if i == 0: text = lines[i]
        else: text += "\n" + lines[i]
    
    if not is_inside_tree(): yield(self, "tree_entered")
    $VBoxContainer/ScrollContainer/Label.text = text
    yield(get_tree(), "idle_frame")
    $VBoxContainer/ScrollContainer.scroll_vertical = $VBoxContainer/ScrollContainer.get_v_scrollbar().max_value
