class_name InGameConsole
extends Panel

signal submitted_line(line)

export var max_lines = 100

var lines = []

onready var line_edit = $VBoxContainer/LineEdit
onready var instructions = $VBoxContainer/Instructions

func _ready():
    var _1 = line_edit.connect("text_entered", self, "submit_line")

func _input(event):
    if event.is_action_pressed("ui_accept"):
        if not line_edit.visible:
            focus_line_edit()

func submit_line(line):
    line_edit.clear()
    #write_line(line) # Display when receiving not sending...
    line_edit.visible = false
    instructions.visible = true
    line_edit.release_focus()
    emit_signal("submitted_line", line)

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

func focus_line_edit():
    line_edit.visible = true
    instructions.visible = false
    yield(get_tree(), "idle_frame")
    line_edit.grab_focus()
