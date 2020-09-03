extends AudioStreamPlayer

func _ready():
    var _1 = Settings.connect("sound_changed", self, "stop_sound")

func stop_sound(sound_on):
    if not sound_on:
        playing = false

func play(default = 0.0):
    if Settings.sound_on:
        .play(default)
