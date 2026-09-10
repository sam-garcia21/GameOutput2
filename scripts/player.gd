extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const SPRINT_SPEED = 500.0

const JUMP_VELOCITY = -400.0
const MIN_JUMP_VELOCITY = -200.0


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get movement direction
	var direction := Input.get_axis("left", "right")

	# Sprint
	var current_speed = SPEED

	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED

	# Movement
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Short jump if player releases jump early
	if Input.is_action_just_released("jump") and velocity.y < MIN_JUMP_VELOCITY:
		velocity.y = MIN_JUMP_VELOCITY

	# Flip sprite
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

	# Animation
	if not is_on_floor():
		animated_sprite_2d.play("jump")
	elif abs(velocity.x) > 1:
		if Input.is_action_pressed("sprint"):
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()
