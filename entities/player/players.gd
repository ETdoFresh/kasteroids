extends Node

var players = []

func add_player(ship : Ship, input):
    players.append({"ship": ship, "input": input})

func remove_player_by_ship(ship : Ship):
    var player = lookup("ship", ship)
    if player: players.erase(player)

func remove_player_by_input(input):
    var player = lookup("input", input)
    if player: players.erase(player)

func update_ship_inputs(tick):
    for player in players:
        if player.input.has_method("set_state_at_tick"):
            if not player.input.set_state_at_tick(tick):
                player.input.misses += 1
        player.ship.input = player.input

func lookup(key, value):
    for player in players:
        if player.has(key):
            if player[key] == value:
                return player
    return null
