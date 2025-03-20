extends Node

var same_level: Callable
var place_decide: Callable

var _direction: Vector2i = Vector2i.ZERO
var _plane: Array[Array] = []
var _try: bool = false

func set_direction(direction: Vector2i) -> void:
	_direction = direction

func _for_direction(action: Callable) -> void:
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		action.call(axis)

func _observe_ledge(axis: int, ledge: Vector2) -> void:
	var faced: int = _direction[axis]
	_try = _try and _plane[axis][faced].call(ledge)

func setup(hero: CharacterBody2D):
	_for_direction(func(a): _plane.push_back(place_decide.call(hero, a)))

func _observe(ledge: Vector2) -> bool:
	_try = true
	_for_direction(func(a): _observe_ledge(a, ledge))
	return _try

func reach(stand: Area2D) -> bool:
	var pos: Vector2 = stand.get_ledge_position()
	var place: Node = stand.seat.place
	var _floor: int = stand.seat.F

	return place.empty() and _observe(pos) and same_level.call(_floor)
