extends Node

signal jump(direction: Vector2i)

const NEUTRAL: int = 0
const PERIOD: float = 0.025
const FREEZE: float = 0.075

var time: float = PERIOD

func _platforming(input: Node) -> void:
	if input.direction != Vector2i.ZERO:
		jump.emit(input.direction)
		time += FREEZE

func _tick_jumps(input: Node) -> void:
	time -= input.delta
	if time <= NEUTRAL:
		time = PERIOD
		_platforming(input)
