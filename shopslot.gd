extends Node2D

@export var items : Array[Item]
@export var selectedItem : Item

@onready var sprite := $Sprite2D
@onready var showText := $ShowText
@onready var itemNameText := $UI/VBoxContainer/Name
@onready var itemStatsText := $UI/VBoxContainer/Stats
@onready var vBox := $UI/VBoxContainer
@onready var colorRect := $UI/ColorRect

var isWeapon : bool

var health : float
var mana : float
var speed : float
var cooldown : float
var value : int
var type : Global.itemType 


# Called when the node enters the scene tree for the first time.
func _ready():
	var text = ""
	var size = items.size()
	var selection = randi() % size
	selectedItem = items[selection]
	sprite.texture = selectedItem.sprite
	health = selectedItem.health
	mana = selectedItem.mana
	speed = selectedItem.speed
	cooldown = selectedItem.cooldown
	value = selectedItem.value
	type = selectedItem.type
	vBox.modulate = Color(1, 1, 1, 0)
	colorRect.modulate = Color(0.5, 0.5, 0.5, 0)
	colorRect.size.y = vBox.size.y / 5
	if health != 0:
		text += ("+" + str(health) + " Health\n")
	if mana != 0:
		text += ("+" + str(mana) + " Mana\n")
	if speed != 0:
		text += ("+" + str(speed) + " Speed\n")
	if cooldown != 0:
		text += ("-" + str(cooldown) + "s Cooldown\n")
	if value != 0:
		text += (str(value) + " Gold")
	print(text)
	match(type):
		Global.itemType.RED:
			itemNameText.modulate = Color(1, 0, 0, 1)
		Global.itemType.GREEN:
			itemNameText.modulate = Color(0, 1, 0, 1)
		Global.itemType.BLUE:
			itemNameText.modulate = Color(0, 0, 1, 1)
	itemNameText.text = str("[center]") + selectedItem.name + str("[/center]")
	itemStatsText.text = str("[center]") + text + str("[/center]")
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_show_text_area_entered(area):
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(vBox, "modulate", Color(1, 1, 1, 1), 0.3)
	tween2.tween_property(colorRect, "modulate", Color(0.5, 0.5, 0.5, 0.5), 0.3)
	
	
	


func _on_show_text_area_exited(area):
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(vBox, "modulate", Color(1, 1, 1, 0), 0.3)
	tween2.tween_property(colorRect, "modulate", Color(0.5, 0.5, 0.5, 0), 0.3)
