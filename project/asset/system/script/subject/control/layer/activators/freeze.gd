extends Node

var execute: TileMapLayer

@onready var particle = preload("res://asset/system/scene/subject/control/drive/fire.tscn")

func break_ice(pos: Vector2, coords: Vector2i, damage: int) -> void:
	var resistance: int = Tile.extract(execute, coords, Tile.BREAK)
	if resistance > damage: return

	var fire = particle.instantiate()
	fire.position = pos
	execute.get_parent().add_child(fire)
	execute.erase_cell(coords)

func activate(pos: Vector2, damage: int) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos)
	print("FREEZE: ", tile.atlas, " + DAMAGE: ", damage)

	match tile.atlas:
		Vector2i(2, 1), Vector2i(3, 1):
			break_ice(pos, tile.coords, damage)
		_: pass
