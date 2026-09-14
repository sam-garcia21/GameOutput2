extends Path2D

@export var SPEED = 70.0
@onready var npc: PathFollow2D = $NPC
@onready var animated_sprite_2d: AnimatedSprite2D = $NPC/AnimatedSprite2D

enum states{WALKING, STOP}

var state = states.WALKING
var prev_position = Vector2.ZERO

func _ready() -> void:
	animated_sprite_2d.play("walk")

func _process(delta: float) -> void:
	if state == states.WALKING:
		npc.progress += SPEED * delta
		if npc.global_position.x > prev_position.x:
			animated_sprite_2d.flip_h = false
		elif npc.global_position.x < prev_position.x:
			animated_sprite_2d.flip_h = true
		prev_position.x = npc.global_position.x

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		state = states.STOP
		animated_sprite_2d.play("idle")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		state = states.WALKING
		animated_sprite_2d.play("walk")
