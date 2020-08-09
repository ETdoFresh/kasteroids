extends Button

func _ready():
    var _1 = connect("pressed", self, "menu_gui_press")

func menu_gui_press():
    var _1 = get_tree().change_scene_to(Scene.MENU)
