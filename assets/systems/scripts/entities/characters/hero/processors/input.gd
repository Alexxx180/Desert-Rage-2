extends Node

signal directing(direction: Vector2i)

@onready var x: Node = $horizontal
@onready var y: Node = $vertical

var delta: float = 0.0
var direction: Vector2i = Vector2i.ZERO
var directed: Vector2i = direction

func _input(_event):
	direction = Vector2i(x.axis, y.axis)
	if direction != Vector2i.ZERO:
		directed = direction
	directing.emit(direction)

func _physics_process(dt: float): delta = dt
