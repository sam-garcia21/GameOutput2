extends Node2D
@export var BOUNCE_STRENGTH = 500.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		body._bounce(rotation, BOUNCE_STRENGTH)
