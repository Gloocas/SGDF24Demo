extends Node2D
class_name World

@onready var network : PackedScene = preload("res://src/network.tscn")
@onready var template : PackedScene = preload("res://src/room_template.tscn")
@onready var camera = $Camera2D

func _ready():
	var network_inst = network.instantiate()
	network_inst.global_position = Vector2(0,0)
	self.add_child(network_inst)

func spawn_world():
	var template_inst = template.instantiate()
	template_inst.global_position = Vector2(0,0)
	self.add_child(template_inst)
	camera.zoom = Vector2(1,1)
	pass
