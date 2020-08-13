extends Node

var ship_dictionary = {}
var input_dictionary = {}

func add_player(ship : Ship, input):
    ship_dictionary[ship] = input
    input_dictionary[input] = ship

func remove_player_by_ship(ship : Ship):
    if ship_dictionary.has(ship):
        input_dictionary.erase(ship_dictionary[ship])
        ship_dictionary.erase(ship)

func remove_player_by_input(input):
    if input_dictionary.has(input):
        ship_dictionary.erase(input_dictionary[input])
        input_dictionary.erase(input)

func get_input(ship : Ship):
    return ship_dictionary[ship]

func get_ship(input):
    return input_dictionary[input]

func update_ship_inputs():
    for ship in ship_dictionary.keys():
        ship.update_input(ship_dictionary[ship])
