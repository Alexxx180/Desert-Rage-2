extends Node

var location: Node
var chests: Node

const ID: int = 0

func activate(pos: Vector2) -> void:
	map_check(location.search.atlas.find_cell(pos))

func map_check(map_coords: Vector2i) -> void:
	if map_coords != Lockers.EMPTY:
		map_activate(map_coords)

func map_activate(map_coords: Vector2i) -> void: # location.search.border # , ID
	var tile: Dictionary = chests.lay.border.context
	# search.border.context.coords
	# var atlas: Vector2i = chests.lay.border.from_coords(map_coords).context.atlas
	print("ATLAS, P: ", tile.atlas)#, " - N: ", atlas)
	if chests.chest.on_at(tile.atlas) or chests.chest.off_at(tile.atlas): # TODO FIX 5 0
		chests.open_chests()
	elif location.search.atlas.has_trigger(map_coords):
		location.search.activate(map_coords)
