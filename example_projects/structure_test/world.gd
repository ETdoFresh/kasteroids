extends Node2D

export var players = []

func add_player(input):
    var ship = Scene.STRUCTURE_TEST_SHIP.instance()
    add_child(ship)
    ship.input = input
    players.append(ship)

func remove_player(input):
    for i in range(players.size() - 1, -1, -1):
        if players[i].input == input:
            remove_child(players[i])
            players.remove(i)
