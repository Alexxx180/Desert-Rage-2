extends Node

enum { GROUND = 1, INTERACTION = 4 }

var tags: TileMapLayer
var border: TileMapLayer

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		Tile.paint(border, { "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return
	for chest in [0, 1, 2]:
		_paint(tags.get_used_cells_by_id(INTERACTION, Vector2i(0, chest)))

func setup(_tags: TileMapLayer, _border: TileMapLayer, casual_mode: bool) -> void:
	tags = _tags
	border = _border
	# _set_casual_mode(casual_mode)

func open_chest(hero: CharacterBody2D, pos: Vector2) -> void:
	var chest: Dictionary = Tile.from_pos(border, pos)
	var atlas: Vector2i = Tile.from_pos(tags, pos).atlas
	if chest.atlas.x == 0:
		Tile.switch(chest, Vector2i(1, 0), border)
		hero.put_to_inventory(atlas)
	else:
		hero.remember_inventory(atlas)
