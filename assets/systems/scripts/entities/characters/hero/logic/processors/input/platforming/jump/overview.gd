extends Node

var _F: int = 0
var direction: Vector2i = Vector2i.ZERO
var _directions: OverviewDirections

func redirect(next: Vector2i) -> void: direction = next
func set_floor(F: int) -> void: _F = F

func set_floor_change(surface: Node) -> void:
	surface.floors.on_floor_change.connect(set_floor)

func set_control_entity(hero: CharacterBody2D) -> void:
	set_floor_change(hero.logic.processors.environment.surface)
	_directions = OverviewDirections.new(hero)

func observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and _directions.observe(axis, direction, ledge)
	return try

func reach(ledge: Node2D) -> bool:
	var target: Node = ledge.surface
	return (not target.seat.has_hero and
		_F == target.F and observe(ledge.pos))
