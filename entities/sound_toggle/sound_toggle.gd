extends TextureRect

export var off_texture : Texture
export var on_texture : Texture

func _ready():
    set_pressed(Settings.sound_on)

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            set_pressed(not Settings.sound_on)
            Settings.save_file()

func set_pressed(value):
    Settings.sound_on = value
    texture = on_texture if value else off_texture
