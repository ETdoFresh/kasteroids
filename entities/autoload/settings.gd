extends Node

const VERSION = "v0.0.8"
const SETTINGS_FILE = "user://settings.tres"

signal music_changed(value)
signal sound_changed(value)

var music_on = true setget change_music_on
var sound_on = true setget change_sound_on
var client_url = "wss://etdofresh-games.ddns.net:11001"
var ticks_per_second = 60 setget set_ticks_per_second
var tick_rate = 1.0 / 60 setget set_tick_rate
var settings_file

func _enter_tree():
    load_from_file()

func _ready():
    print("Kasteroids %s" % VERSION)

func set_ticks_per_second(value : float):
    ticks_per_second = value
    tick_rate = 1.0 / value if value != 0.0 else 0.0

func set_tick_rate(value : float):
    tick_rate = value
    ticks_per_second = 1 / value if value != 0.0 else 0.0

func change_music_on(value):
    music_on = value
    emit_signal("music_changed", value)

func change_sound_on(value):
    sound_on = value
    emit_signal("sound_changed", value)

func load_from_file():
    settings_file = ResourceLoader.load(SETTINGS_FILE)
    if settings_file:
        change_music_on(settings_file.music_on)
        change_sound_on(settings_file.sound_on)
    else:
        settings_file = SettingsFile.new()
        settings_file.music_on = music_on
        settings_file.sound_on = sound_on

func save_file():
    settings_file.music_on = music_on
    settings_file.sound_on = sound_on
    var _1 = ResourceSaver.save(SETTINGS_FILE, settings_file)
