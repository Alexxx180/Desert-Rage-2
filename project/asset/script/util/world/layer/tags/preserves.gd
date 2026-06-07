class_name Preserves extends Node

enum { GROUND = 1, TILE_SIZE = 6 }

func is_chest(atlas: Vector2i) -> bool:
	return Def.of8(atlas) in [Def.BRONZE_OFF, Def.SILVER_OFF, Def.GOLD_OFF,
		Def.PLATINUM_OFF, Def.BRONZE_ON, Def.SILVER_ON, Def.GOLD_ON, Def.PLATINUM_ON]

func _paint(places: Array[Vector2i]) -> void:
	for coords in places:
		HUD.level.border.paint({ "id": GROUND, "atlas": Vector2i.ONE, "coords": coords })

func _set_casual_mode(casual_mode: bool) -> void:
	if not casual_mode: return # for chest in [0, 1, 2]: _paint(tags.get_used_cells_by_id(ENEMY, Vector2i(0, chest)))

func setup(_casual_mode: bool) -> void:
	for tag in HUD.level.execute.layer.get_used_cells_by_id(Def.FLOOR):
		set_pages(tag)
	# _set_casual_mode(casual_mode)

func drink_water(inventory: Node, pos: Vector2) -> void:
	match Def.of8(HUD.level.border.tpos(pos)):
		Def.D_WATER:
			inventory.logic.effect.restore() # USE WATER

func _get_id(tile: Dictionary) -> int:
	var tag: Vector2i = HUD.level.execute.tile(tile.coords)
	print("ITEM ID = ", Tile.logic_no(tag, TILE_SIZE))
	return Def.of8(tag) - Tile.FLOOR

func open_chest(tile: Dictionary) -> void:
	var id: int = _get_id(tile)
	var hero: CharacterBody2D = HUD.level.group.deploy.party.leader
	var logic: Node = hero.to.inventory.logic
	# lay.border.switch(chest.offset.on) # TODO NEED TO ADD CHECK BEFORE CHANGE
	var slot: int = logic.put_to_inventory(id)
	if logic.items.ui.have(slot):
		logic.trade.equip.add_weapon(slot)
	logic.effect.remember(id)

func open_chests() -> void:
	var tile: Dictionary = HUD.level.border.context # print("FOUND ID: ", id) # logic.effect.status.hero = hero
	match Def.of8(tile.atlas):
		Def.BRONZE_OFF, Def.SILVER_OFF, Def.GOLD_OFF, Def.PLATINUM_OFF:
			open_chest(tile)
		Def.BRONZE_ON, Def.SILVER_ON, Def.GOLD_ON, Def.PLATINUM_ON:
			var logic: Node = HUD.level.group.deploy.party.leader.to.inventory.logic
			logic.effect.remember(_get_id(tile))

# TODO BOOKS
func check_book() -> void:
	var tile: Dictionary = HUD.level.border.context
	var books: Dictionary = HUD.level.execute.manual.books
	if books[tile.atlas].size() > 0:
		var manual: String = books[tile.atlas][0]#[message]
		set_page(tile.coords, [tile.atlas, manual])

func set_book(tag: Vector2i) -> void:
	match Def.of8(HUD.level.border.tile(tag)):
		Def.BLUE_OFF, Def.RED_OFF, Def.GREEN_OFF, Def.BLACK_OFF, Def.WHITE_OFF: check_book()

func set_page(coords: Vector2i, value: Array) -> void:
	HUD.level.execute.books[coords] = value

func _manual(coords: Vector2i) -> String:
	return Def.master.manual[Def.master.PAGES + Def.of8(HUD.level.execute.from_coords(coords).tatlas)]

func set_pages(tag: Vector2i) -> void:
	var tile: Dictionary = HUD.level.execute.from_coords(tag).context
	match Def.of8(tile.atlas):
		Def.PAGE: set_page(tile.coords, [tile.atlas, _manual(tile.coords)])
		_: set_book(tile.coords)
