extends Node

var surface: Node
var direction: Vector2i = Vector2i.ZERO

@onready var directions: Node = $directions

func set_control_entity(hero: CharacterBody2D) -> void:
	surface = hero.detectors.platform.floors.surface
	directions.init(hero)

func observe(ledge: Vector2) -> bool:
	var try: bool = true
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		try = try and directions.observe(axis, direction, ledge)
	return try

func reach(ledge: Node2D) -> bool:
	return (not ledge.surface.seat.has_hero
		and surface.F == ledge.surface.F
		and observe(ledge.pos))
