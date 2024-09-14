extends Node

signal jump()

const NEUTRAL: int = 0
const PERIOD: float = 0.025
const FREEZE: float = 0.075

var time: float = PERIOD
var overview: Node

func _platforming() -> void:
	if overview.direction != Vector2i.ZERO:
		jump.emit()
		time += FREEZE

func _physics_process(delta: float) -> void:
	time -= delta
	if time <= NEUTRAL:
		time = PERIOD
		_platforming()
