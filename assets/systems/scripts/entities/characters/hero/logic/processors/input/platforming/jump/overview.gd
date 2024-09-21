extends Node

var F: int = 0
var direction: Vector2i = Vector2i.ZERO
var _directions: OverviewDirections

func redirect(next: Vector2i) -> void: direction = next
func set_floor(f: int) -> void: F = f

func set_control_entity(hero: CharacterBody2D) -> void:
	var environment: Node = hero.logic.processors.environment
	var floors: Node = environment.surface.floors
	
	floors.on_floor_change.connect(set_floor)
	_directions = OverviewDirections.new(hero)

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and _directions.observe(axis, direction, ledge)
	return try

func reach(ledge: Node2D) -> bool:
	var seat: Node = ledge.surface.seat
	return not seat.has_hero and _observe(ledge.pos)
