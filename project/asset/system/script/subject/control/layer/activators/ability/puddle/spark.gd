extends Node

var execute: TileMapLayer

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")

const PUDDLE: Vector2i = Vector2i(1, 2)
const ID: int = 2

func sparking(tile: Dictionary, direction: Vector2i) -> void:
	"""
	var spark = particle.instantiate()
	spark.position = pos
	spark.set_direction(direction)
	execute.get_parent().add_child(spark)
	"""
	tile.atlas = PUDDLE
	tile.id = ID
	#print("TILE ATLAS: ", tile.atlas, " + COORDS: ", tile.coords)
	Tile.paint(execute, tile)

func activate(pos: Vector2, direction: Vector2i) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos)
	match tile.atlas:
		Vector2i(0, 2):
			sparking(tile, direction)
			print("AND NOW WHAT? ", tile.atlas)
		_:
			print("BUT ATLAS IS: ", tile.atlas)
			pass
