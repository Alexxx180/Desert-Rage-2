extends Node

var search: StorageSearch = StorageSearch.new()

func empty(tile: Vector2i) -> bool: return tile == Def.VECTI

func check_weight(map_coords: Vector2i, appendix: int) -> bool:
	var trigger: Dictionary = search.storage.get_trigger(map_coords)
	trigger.count += appendix
	return trigger.count == clamp(appendix, 0, 1)
	
func switch(pos: Vector2, appendix: int) -> void:
	var map_coords: Vector2i = search.get_border_tile_coords(pos)
	if not empty(map_coords) and check_weight(map_coords, appendix):
		map_activate(map_coords)

func activate_trigger(pos: Vector2) -> void:
	var map_coords: Vector2i = search.get_border_tile_coords(pos)
	if not empty(map_coords): map_activate(map_coords)

func deactivate_button(pos: Vector2) -> void: switch(pos, -1)

func activate_button(pos: Vector2) -> void: switch(pos, 1)

func map_activate(map_coords: Vector2i) -> void: search.activate(map_coords)

func setup(root: LevelRoot) -> void:
	search.root = root
	for x in range(5):
		for y in range(5):
			var atlas: Vector2i = Vector2i(x, y)
			var busy: Array[Vector2i] = root.execute.busy(atlas, Lockers.SOURCE)
			search.storage.setup(root.border, atlas, busy)
