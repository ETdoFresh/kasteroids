class_name FPGame

static func start(node: Node):
    var game = empty_game_record(node)
    game = get_leader_board(game)
    game = get_score(game)
    return game

static func empty_game_record(node: Node):
    var scene_name = node.get_tree().current_scene.name
    var record = GameRecord.new()
    record.node = node
    record.current_scene = CurrentSceneRecord.new().init(scene_name)
    record.leader_board = LeaderBoardRecord.new()
    record.active_session = NoSessionRecord.new()
    record.settings = SettingsRecord.new()
    record.score = ScoreRecord.new()
    return record

static func get_leader_board(game: GameRecord):
    return game

static func get_score(game: GameRecord):
    return game

static func load_logo_scene(game: GameRecord):
    game = game.duplicate()
    game.current_scene.set_value("Logo")
    var _1 = game.node.get_tree().change_scene_to(Scene.LOGO)
    return game

static func load_menu_scene(game: GameRecord):
    game = game.duplicate()
    game.current_scene.set_value("Main Menu")
    var _1 = game.node.get_tree().change_scene_to(Scene.MENU)
    return game

static func load_single_player_level(game: GameRecord, level: int):
    game = game.duplicate()
    game.current_scene.set_value("Single Player Level %s" % str(level))
    var _1 = game.node.get_tree().change_scene_to(Scene["LEVEL%s" % str(level)])
    return game

static func show_logo(game):
    return game.load_logo_image().wait()

static func show_menu(game):
    return game.load_menu()

static func start_singleplayer_game(game):
    return game.load_level_select()

static func start_singleplayer_level(game):
    return game.load_level()

static func start_multiplayer_game(game):
    return game.load_multiplayer_lobby()

static func start_multiplayer_matchmaking(game):
    return game.load_matchmaking_wait_screen()

static func start_multiplayer_level(game):
    return game.load_multiplayer_level()

static func layout(game):
    return game \
        .logo() \
        .main_menu() \
            .single_player() \
                .level_select() \
                    .asteroids() \
                    .soccer() \
                    .space_invaders() \
                    .lunar_lander() \
                    .missle_command() \
                .levels() \
            .multiplayer() \
                .lobby() \
                .matchmake() \
                .best_3_out_of_5() \
            .settings() \
                .input() \
                .audio() \
                .visual() \
            .credits()
