extends Node

enum { GROUND = 1, ENEMY = 4, CHESTS = 5 }

var lay: Node
var group: Node2D
var FLOW: Array[Vector2i] = TilesTape.list(3, 0, 3, 1)

var chest: TilesTape = TilesTape.new(2, 0).add("BRONZE").add("SILVER").add("GOLD").add("PLATINUM")

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		lay.border.paint({ "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return # for chest in [0, 1, 2]: _paint(tags.get_used_cells_by_id(ENEMY, Vector2i(0, chest)))

func setup(_lay: Node, _casual_mode: bool) -> void: lay = _lay
# _set_casual_mode(casual_mode)

func drink_water(inventory: Node, pos: Vector2) -> void:
	if lay.border.from_pos(pos).context.atlas in FLOW:
		inventory.logic.effect.restore() # USE WATER

func open_chests() -> void:
	var tile: Dictionary = lay.border.context
	var id: int = Tile.logic_no(lay.tags.from_coords(tile.coords).context.atlas)
	var logic: Node = group.leader.to.inventory.logic
	if chest.on_at(tile.atlas):
		logic.remember_inventory(id)
	elif chest.off_at(tile.atlas):
		lay.border.switch(chest.offset.on) # TODO NEED TO ADD CHECK BEFORE CHANGE
		logic.put_to_inventory(id)
