extends Path2D

@export var SPEED = 70.0
@onready var platform: PathFollow2D = $PathFollow2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	platform.progress += SPEED * delta
	pass
