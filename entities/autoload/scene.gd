extends Node

# Scenes
const LOCAL_GAME = preload("res://scenes/local/local.tscn")
const TCP_SERVER_GAME = preload("res://scenes/tcp/server.tscn")
const TCP_CLIENT_GAME = preload("res://scenes/tcp/client.tscn")
const TCP_BOTH_GAME = preload("res://scenes/tcp/both.tscn")
const WEB_SOCKET_SERVER_GAME = preload("res://scenes/web_socket/server.tscn")
const WEB_SOCKET_CLIENT_GAME = preload("res://scenes/web_socket/client.tscn")
const WEB_SOCKET_BOTH_GAME = preload("res://scenes/web_socket/both.tscn")

# Entities
const ASTEROID_CLIENT = preload("res://entities/asteroid/asteroid_client.tscn")
const BULLET = preload("res://entities/bullet/bullet.tscn")
const BULLET_CLIENT = preload("res://entities/bullet/bullet_client.tscn")
const BULLET_PARTICLES = preload("res://entities/bullet/bullet_particles.tscn")
const KEYBOARD_PLUS_GUI = preload("res://entities/input/keyboard_plus_gui.tscn")
const MENU = preload("res://scenes/menu/menu.tscn")
const PLAYER = preload("res://entities/player/player.tscn")
const SHIP = preload("res://entities/ship/ship.tscn")
const SHIP_CLIENT = preload("res://entities/ship/ship_client.tscn")
const STRUCTURE_TEST_SHIP = preload("res://example_projects/structure_test/ship.tscn")
