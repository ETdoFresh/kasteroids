extends Node

var game

func _ready():
    game = FPGame.start(self)

func _input(event):
    ShortcutFunctions.receive_input(event)

func load_logo_scene():
    game = FPGame.load_logo_scene(game)

func load_menu_scene():
    game = FPGame.load_menu_scene(game)

func load_single_player_level_select():
    game = FPGame.load_single_player_level_select(game)

func load_multiplayer_lobby():
    game = FPGame.load_multiplayer_lobby(game)

func load_single_player_level(level: int):
    game = FPGame.load_single_player_level(game, level)
