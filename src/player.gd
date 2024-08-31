extends CharacterBody2D

@onready var floorArea := $FloorChecker
@onready var animPlayer := $AnimationPlayer
@onready var hurtBox := $HurtArea/HurtBox

var Speed := 0.0
var topSpeed := 150.0

const SPEED_INC := 15.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var canDash := true
var canDodge := true
var hDirection := 0.0
var vDirection := 0.0 

func _enter_tree():
	set_multiplayer_authority(name.to_int())
 
func _physics_process(delta):
	if is_multiplayer_authority():
		handle_input(delta)
		if Input.is_action_just_pressed("Dash"):
			dash()
		elif Input.is_action_just_pressed("Dodge"):
			dodge()
	move_and_slide()

func dash():
	if canDash:
		Speed *= 3
		hurtBox.disabled = true
		canDash = false
		await get_tree().create_timer(0.25).timeout
		print("donedash")
		hurtBox.disabled = false
		await get_tree().create_timer(3).timeout
		canDash = true
		
func dodge():
	if canDodge and velocity.length() > 5: #if player is moving, dodge in current direction
		hurtBox.disabled = true
		canDodge = false
		await get_tree().create_timer(0.3).timeout
		print("donedodge")
		hurtBox.disabled = false
		await get_tree().create_timer(0.45).timeout
		canDodge = true
	elif canDodge: #if not moving, dodge player to the right (change this later to dodge in direction player faces)
		velocity.x = 200.0
		hurtBox.disabled = true
		canDodge = false
		await get_tree().create_timer(0.3).timeout
		print("donedodge")
		hurtBox.disabled = false
		await get_tree().create_timer(0.45).timeout
		canDodge = true

func handle_input(delta):
	hDirection = Input.get_axis("Left", "Right")
	vDirection = Input.get_axis("Up", "Down")
	if true: #floorArea.has_overlapping_bodies(): #if player's area isn't within floor area, remove movement and add gravity
		if hDirection and vDirection:
			Speed = move_toward(Speed, topSpeed, SPEED_INC) #slowed velocity's to account for increased movement
			velocity.x = hDirection * Speed / 1.4
			velocity.y = vDirection * Speed / 1.4
		elif hDirection:
			Speed = move_toward(Speed, topSpeed, SPEED_INC)
			velocity.x = hDirection * Speed
			velocity.y = move_toward(velocity.y, 0, SPEED_INC)
		elif vDirection:
			Speed = move_toward(Speed, topSpeed, SPEED_INC)
			velocity.y = vDirection * Speed
			velocity.x = move_toward(velocity.x, 0, SPEED_INC)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED_INC)
			velocity.y = move_toward(velocity.y, 0, SPEED_INC)
	else:
		velocity.y += gravity * delta
		
