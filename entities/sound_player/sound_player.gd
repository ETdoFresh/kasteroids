extends AudioStreamPlayer

func _ready():
    var _1 = Settings.connect("sound_changed", self, "stop_sound")
    if Settings.sound_on:
        play()

func stop_sound(sound_on):
    if not sound_on:
        playing = false
