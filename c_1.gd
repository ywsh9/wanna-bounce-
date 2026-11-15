extends CharacterBody2D

@onready var sprite = $Sprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const fat_texture = preload("res://fat_fc1.png")
const thin_texture = preload("res://thin_fc1.png")
var is_fat = false
var grav_mult = 1.0
@onready var jump = $jump

func _ready() -> void:
	velocity = Vector2(1, 1).normalized() * SPEED

func _input(event: InputEvent) -> void:
	if event is InputEventKey :
		if event.is_action_pressed("E") :
			sprite.texture = fat_texture
			is_fat = true
			grav_mult = 0.58
		elif event.is_action_released("E") :
			sprite.texture = thin_texture
			is_fat = false
			grav_mult = 1

func _physics_process(delta: float) -> void:
	var gravity = 980
	
	if not is_on_floor():
		velocity.y += gravity * delta * grav_mult

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * (1/(grav_mult))
		jump.play()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("A", "D")
	if direction == 0:
		direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var last_velocity = velocity
	move_and_slide()
	if get_slide_collision_count()>0 and is_fat==true:
		var collision = get_slide_collision(0)
		var normal = collision.get_normal()
		var bounce = last_velocity.bounce(normal)
		
		velocity = last_velocity.bounce(normal)
		if normal.y < -0.5 :
			velocity = bounce
		elif abs(normal.x) > 0.5 :
			bounce.y = min(last_velocity.bounce(normal).y, -200.0)
			
	if global_position.y > 655 :
		get_tree().change_scene_to_file("res://main.tscn")
	#if is_on_wall():
	#	velocity.x = -velocity.x * bounce_multiplier
	#get_slide_collision_count()
