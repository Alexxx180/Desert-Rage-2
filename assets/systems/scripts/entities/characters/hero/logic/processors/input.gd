extends Node

signal directing(direction: Vector2i)

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming

var x: InputAxis = InputAxis.new("left", "right")
var y: InputAxis = InputAxis.new("forward", "backward")

func _input(_event: InputEvent) -> void:
	directing.emit(Vector2i(x.axis, y.axis))
