extends Node

enum { GROUND = 1, INTERACTION = 4 }

var tags: TileMapLayer

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		Tile.paint(tags.border, { "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return
	for chest in [0, 1, 2]:
		_paint(tags.get_used_cells_by_id(INTERACTION, Vector2i(0, chest)))

func setup(_tags: TileMapLayer, casual_mode: bool) -> void:
	tags = _tags
	# _set_casual_mode(casual_mode)

func open_chest(inventory: Node, pos: Vector2) -> void:
	var chest: Dictionary = Tile.from_pos(tags.border, pos)
	var atlas: Vector2i = Tile.from_pos(tags, pos).atlas
	const jar: int = 0
	match chest.atlas:
		Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2):
			inventory.logic.fill_the_jar()
		_:
			if chest.atlas.x == 0:
				Tile.switch(chest, Vector2i(1, 0), tags.border)
				inventory.logic.put_to_inventory(jar)# Tile.logic(atlas))
			else:
				inventory.logic.remember_inventory(jar)# Tile.logic(atlas))
