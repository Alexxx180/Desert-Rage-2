extends Node

var execute: TileDecorator

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")

const PUDDLE: Vector2i = Vector2i(0, 2)
const ID: int = 2

func watering(direction: Vector2i) -> void:
	var rain = particle.instantiate()
	rain.position = execute.context.pos
	rain.set_direction(direction)
	execute.add_chip(rain).select(PUDDLE, ID).paint()

func activate(pos: Vector2, direction: Vector2i) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2(-1, -1): # Vector2i(2, 1), Vector2i(3, 1):
			watering(direction)
			print("RN| ATLAS IS (Y): ", execute.context.atlas)
		_:
			print("RN| ATLAS IS (N): ", execute.context.atlas)
