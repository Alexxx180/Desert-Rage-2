extends Node2D

@onready var trap: Sprite2D = $trap
@onready var wall: StaticBody2D = $wall
@onready var plane: Node2D = $plane
@onready var hero: ShapeCast2D = $hero
@onready var current: ShapeCast2D = $current

var open: bool

func sync_trap() -> bool:
	open = plane.is_colliding()
	# wall.visible = not open
	Processors.turn(wall, not open)
	trap.visible = open
	return open

func move() -> bool:
	return not sync_trap() and hero.is_colliding()

func rail() -> bool:
	return current.is_colliding()
