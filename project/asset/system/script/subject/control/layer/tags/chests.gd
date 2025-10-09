extends Node

enum { JAR = 0, GROUND = 1, ENEMY = 4 }

var lay: Node

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		lay.border.paint({ "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return
	# for chest in [0, 1, 2]:
		# _paint(tags.get_used_cells_by_id(ENEMY, Vector2i(0, chest)))

func setup(_lay: Node, casual_mode: bool) -> void:
	lay = _lay
	# _set_casual_mode(casual_mode)

func _bronze_chest(logic: Node) -> void:
	if lay.border.context.atlas.x == 0: # var atlas: Vector2i = lay.tags.from_pos(tags)
		lay.border.switch(Vector2i(1, 0))
		logic.put_to_inventory(JAR)# Tile.logic(atlas))
	else:
		logic.remember_inventory(JAR)# Tile.logic(atlas))

func open_chest(inventory: Node, pos: Vector2) -> void:
	match lay.border.from_pos(pos).context.atlas:
		Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2):
			inventory.logic.fill_the_jar()
		_: _bronze_chest(inventory.logic)
