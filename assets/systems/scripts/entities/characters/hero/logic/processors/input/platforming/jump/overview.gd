extends Node

var _directions: OverviewDirections

@onready var hero: Node = $direction
@onready var height: Node = $height

func set_control_entity(hero: CharacterBody2D) -> void:
	_directions = OverviewDirections.new(hero)

func _observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and _directions.observe(axis, hero.direction, ledge)
	return try

func reach(ledge: Node2D) -> bool:
	var seat: Node = ledge.surface.seat
	return not seat.has_hero and _observe(ledge.pos)
