extends Resource
class_name Item


@export var sprite : Texture
@export var name : String

#base good guy stat boosts/characteristics (passive items + weapons)
@export var health : float
@export var mana : float
@export var speed : float
@export var cooldown : float
@export var value : int
@export var type : Global.itemType



#weapon stats (weapons only)
@export var damage : float
@export var attackSpeed : float
@export var manaCost : float

