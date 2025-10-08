extends Node

var env: Node
var caught: bool = false
var target_pos: Vector2

@onready var ledge: Dictionary = { "node": Defaults.NODE, "offset": 0 }

func ledge_is_near() -> bool:
	for pillar in env.jump.walls:
		if pillar.is_colliding():
			target_pos = env.jump.position + pillar.position
			return env.floors.same_to_hero(target_pos)
	return false

func is_near() -> bool:
	return not env.jump.border.is_colliding() and ledge_is_near()

func _set_offset(next: Node, offset: float) -> void:
	ledge.node = next
	ledge.offset = offset

func whip_caught(_execute: TileMapLayer) -> void: caught = true
func whip_left(_execute: TileMapLayer) -> void: caught = false

func rotate_whip(pos: Vector2) -> Vector2:
	return env.rotate(pos, ledge.offset)
