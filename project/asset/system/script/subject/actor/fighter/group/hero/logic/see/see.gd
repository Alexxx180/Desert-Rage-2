extends Node2D

@onready var world: Node2D = $world
@onready var levels: Node2D = $levels

var _fight: Node2D = null
var fight: Node2D:
	get:
		if _fight == null:
			_fight = load("res://asset/system/scene/subject/actor/group/hero/ray/logic/see/fight/fight.tscn").instantiate()
			add_child(_fight)
		return _fight

var dir: Vector2i = Vector2i(0, 1)

func set_direction(direction: Vector2i) -> void:
	if direction != Vector2i.ZERO:
		dir = direction
	for area in [world, levels, fight]:
		area.set_direction(direction)
