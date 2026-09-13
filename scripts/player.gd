extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 250.0
const SPRINT_SPEED = 500.0

const JUMP_VELOCITY = -1100.0
const MIN_JUMP_VELOCITY = -500.0

const RESPAWN_POSITION: Vector2 = Vector2(532, 512)


# Determines if character was jumping or not.
var was_jumping = false
var was_falling = false


func _physics_process(delta: float) -> void:
	# check bounce collision tiles
	var bounce_tilemap = get_node("/root/Main/Level1/BounceTiles")
	var collider = get_last_slide_collision()
	if collider:
		if collider.get_collider() == bounce_tilemap:
			if (collider.get_angle() < 0.1):
				velocity += 1500 * Vector2.UP.rotated(collider.get_angle())
				print(velocity)
	
	# check if fell into void
	if position.y > 2000:
		animated_sprite_2d.play("idle")
		position = RESPAWN_POSITION
		return
	
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
		was_jumping = true
		was_falling = false

	if is_on_floor() and Input.is_action_just_pressed("ui_down"):
		set_collision_mask_value(3, false)
		await get_tree().create_timer(0.15).timeout
		set_collision_mask_value(3, true)

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

		# Going upward
		if velocity.y < 0:
			if animated_sprite_2d.animation != "jump":
				animated_sprite_2d.play("jump")

		# Going downward
		else:
			# Character jumped and has just started falling
			if was_jumping and not was_falling:
				animated_sprite_2d.play("fall")
				was_falling = true

			# Character walked off a ledge
			elif not was_jumping:
				animated_sprite_2d.play("fall_loop")


	else:
		# Player is on the ground
		was_jumping = false
		was_falling = false

		if abs(velocity.x) > 1:

			if Input.is_action_pressed("sprint"):
				animated_sprite_2d.play("run")
			else:
				animated_sprite_2d.play("walk")

		else:
			animated_sprite_2d.play("idle")


	move_and_slide()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "fall":
		animated_sprite_2d.play("fall_loop")
