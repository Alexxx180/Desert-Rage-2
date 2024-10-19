extends Node

@onready var inplace: Node = $inplace
@onready var eyes: Node = $direction

var _plane: Array[Array] = []

func set_directions(hero: CharacterBody2D):
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		var faced: Facing = Facing.new(hero, axis)
		_plane.push_back(inplace.decide(faced))

func observe(axis: int, ledge: Vector2) -> bool:
	#print("REAL DIR: ", eyes.direction)
	var faced: int = eyes.direction[axis]
	return _plane[axis][faced].call(ledge)
