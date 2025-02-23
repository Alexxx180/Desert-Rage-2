extends Node

var execute: TileMapLayer

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")

const PUDDLE: Vector2i = Vector2i(0, 2)
const ID: int = 2

func watering(pos: Vector2, tile: Dictionary, direction: Vector2i) -> void:
	var rain = particle.instantiate()
	rain.position = pos
	rain.set_direction(direction)
	execute.get_parent().add_child(rain)
	
	tile.atlas = PUDDLE
	tile.id = ID
	
	#print("TILE ATLAS: ", tile.atlas, " + COORDS: ", tile.coords)
	Tile.paint(execute, tile)

func activate(pos: Vector2, direction: Vector2i) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos) # print("FREEZE: ", tile.atlas, " + DAMAGE: ", damage)

	match tile.atlas:
		Vector2(-1, -1): # Vector2i(2, 1), Vector2i(3, 1):
			watering(pos, tile, direction)
			print("AND NOW WHAT? ", tile.atlas)
		_:
			print("BUT ATLAS IS: ", tile.atlas)
			pass
