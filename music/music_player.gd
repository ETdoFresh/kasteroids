extends AudioStreamPlayer

func _ready():
    var _1 = Settings.connect("music_changed", self, "change_music")

func change_music(value):
    playing = value
