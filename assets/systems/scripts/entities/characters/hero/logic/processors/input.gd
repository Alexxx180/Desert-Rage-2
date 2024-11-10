extends Node

signal directing(direction: Vector2i)
signal moving(velocity: Vector2)

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming

#var x: InputAxis = InputAxis.new("left", "right")
#var y: InputAxis = InputAxis.new("forward", "backward")

func get_input_vector() -> Vector2:
	return Input.get_vector("left", "right", "forward", "backward")

func _input(_event: InputEvent) -> void:
	var motion: Vector2 = get_input_vector()
	print("motion: ", motion)
	directing.emit(Vector2i(round(motion.x), round(motion.y)))
	moving.emit(motion)
