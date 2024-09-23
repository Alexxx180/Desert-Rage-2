extends Node

@onready var inplace: Node = $inplace

var _plane: Array[Array] = []

func set_directions(hero: CharacterBody2D):
	var faced: Facing = Facing.new(hero)
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		faced.axis = axis
		_plane.push_back(inplace.decide(faced))

func observe(axis: int, direction: Vector2i, ledge: Vector2) -> bool:
	var faced: int = direction[axis]
	return _plane[axis][faced].call(ledge)
