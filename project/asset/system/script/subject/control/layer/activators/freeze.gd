extends Node

var execute: TileMapLayer
@onready var particle = preload("res://asset/system/scene/subject/control/drive/fire.tscn")

func activate(pos: Vector2) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos)
	print("FREEZE: ", tile.atlas)

	match tile.atlas:
		Vector2i(2, 1):
			#var fire = FireParticle.new()
			var fire = particle.instantiate()
			fire.position = pos
			execute.get_parent().add_child(fire)
			execute.erase_cell(tile.coords)
		_: pass
