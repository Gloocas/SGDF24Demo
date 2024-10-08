extends Control
class_name Network

@onready var Server_IP = $Server_IP
@onready var Device_IP = $Device_IP
@onready var Server_Port = $Server_Port
@onready var player : PackedScene = preload("res://src/player.tscn")
@onready var world = get_parent()

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 20

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}
var players_loaded = 0

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	#Device_IP.text = Network.ip_address

func join_game(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(7000, MAX_CONNECTIONS)
	if error:
		return 0
	multiplayer.multiplayer_peer = peer
	players[1] = player_info
	player_connected.emit(1, player_info)
	return 1

func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)

# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	print("Player connected!")

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_join_pressed():
	#print(Server_IP.text)
	#var try = join_game(Server_IP.text)
	#if true:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	#add_player()
	self.visible = false
	world.spawn_world()

func _on_host_pressed():
	#create_game()
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	self.visible = false
	world.spawn_world()

func add_player(id = 1):
	var player_inst = player.instantiate()
	player_inst.global_position = Vector2(0,0)
	player_inst.name = str(id)
	world.add_child(player_inst)
	#call_deferred("add_child", player_inst)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
