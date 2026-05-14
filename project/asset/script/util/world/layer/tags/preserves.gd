extends Node

enum { GROUND = 1, ENEMY = 4, CHESTS = 5, TILE_SIZE = 6 }

var lay: Node
var group: Node2D
var FLOW: Array[Vector2i] = TilesTape.list(3, 0, 3, 1)

var chest: TilesTape = TilesTape.new(2, 0).add("BRONZE").add("SILVER").add("GOLD").add("PLATINUM")

func is_chest(atlas: Vector2i) -> bool: return chest.on_at(atlas) or chest.off_at(atlas)

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		lay.border.paint({ "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return # for chest in [0, 1, 2]: _paint(tags.get_used_cells_by_id(ENEMY, Vector2i(0, chest)))

func setup(_lay: Node, _casual_mode: bool) -> void: lay = _lay # _set_casual_mode(casual_mode)

func drink_water(inventory: Node, pos: Vector2) -> void:
	if lay.border.from_pos(pos).context.atlas in FLOW:
		inventory.logic.effect.restore() # USE WATER

func _get_id(tag: Dictionary) -> int:
	print("ITEM ID = ", Tile.logic_no(tag.atlas, TILE_SIZE))
	return Tile.logic_no(tag.atlas, TILE_SIZE) - Tile.FLOOR

func open_chests() -> void:
	var tile: Dictionary = lay.border.context
	var id: int = _get_id(lay.tags.from_coords(tile.coords).context)
	# print("FOUND ID: ", id)
	
	var hero: CharacterBody2D = group.deploy.party.leader
	var logic: Node = hero.to.inventory.logic
	logic.effect.status.hero = hero
	
	if chest.on_at(tile.atlas):
		logic.effect.remember(id)
	elif chest.off_at(tile.atlas):
		lay.border.switch(chest.offset.on) # TODO NEED TO ADD CHECK BEFORE CHANGE
		var slot: int = logic.put_to_inventory(id)
		if logic.items.ui.have(slot):
			logic.trade.equip.add_weapon(slot)
		logic.effect.remember(id)


const SOURCE: int = 3

func _message(lay: Node, map_coords: Vector2i) -> int:
	return lay.tags.from_coords(map_coords).logic_no - 1
# TODO BOOKS
func check_book(lay: Node, tile: Dictionary) -> void:
	var books: Dictionary = lay.tags.manual.books
	if (books[tile.atlas].size() > 0):
		var manual: String = books[tile.atlas][0]#[message]
		set_book(lay, tile.coords, [tile.atlas, manual])

func b(x: int, y: int) -> Vector2i: return Vector2i(x, y)
func set_books(lay: Node, tag: Vector2i) -> void:
	var tile: Dictionary = lay.border.from_coords(tag).context
	if [b(3, 0), b(3, 1), b(3, 2), b(3, 3), b(3, 4),
		b(4, 0), b(4, 1), b(4, 2), b(4, 3), b(4, 4)].has(tile.atlas):
		check_book(lay, tile)

func set_book(lay: Node, coords: Vector2i, value: Array) -> void:
	lay.execute.books[coords] = value

func _manual(lay: Node, coords: Vector2i) -> String:
	return lay.tags.manual.pages[_message(lay, coords)]

func set_page(lay: Node, tile: Dictionary) -> void:
	set_book(lay, tile.coords, [tile.atlas, _manual(lay, tile.coords)])

func set_pages(lay: Node, tag: Vector2i) -> void:
	var tile: Dictionary = lay.execute.from_coords(tag).context
	match tile.atlas:
		Vector2i(2, 1): set_page(lay, tile)
		_: set_books(lay, tag)

func setup(lay: Node) -> void:
	for tag in lay.tags.layer.get_used_cells_by_id(SOURCE):
		set_pages(lay, tag)
