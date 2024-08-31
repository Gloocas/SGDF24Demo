extends Node2D
class_name World

@onready var network : PackedScene = preload("res://src/network.tscn")
@onready var player : PackedScene = preload("res://src/player.tscn")

func _ready():
	var network_inst = network.instantiate()
	network_inst.global_position = Vector2(0,0)
	self.add_child(network_inst)
