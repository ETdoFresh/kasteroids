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

func update_ship_inputs():
    for player in players:
        player.ship.update_input(player.input)

func lookup(key, value):
    for player in players:
        if player.has(key):
            if player[key] == value:
                return player
    return null
