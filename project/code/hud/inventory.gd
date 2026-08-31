class_name HeroInventory extends RefCounted

enum { STICKS, OPUNTIA, TUMBLEWEED, TAMARISK, YUKKA, JAR, ANTIDOTE, ANTICOUGH, GOLD_KEY, SECRET_KEY,
	WATER, TEA, ETHER, L_PANTS, I_PANTS, L_ARMOR, I_ARMOR, L_BOOTS, I_BOOTS,
	SHIELD, CORETOOTH, KNUCKLES, SAW_STRING, W_RAPIER, T_RAPIER, SHOE, R_SCHO45,
	R_ENLIGHT, SHOTGUN, BOOMERANG, BUTTER, F_BUTTER, CLEANER, SHARPEN, AMMO,
	BLADE, PUMP, AIM, MISSING_NO, SLOTS = 25, LIMIT = 30, BAG_START = 0, CRAFT = 7, USE = 10, LIMIT_CRAFT = 2,
	ARMOR = 20, WEAPON = 28, KIT = 36, BAG_END = 50, AURA = 0, RESOURCE = 1, AR = 2, CROSS = 2, BOTH = 3,
	PREVIEW_SIZE = 72, ITEMS = 0, SLOT = 1, UNIT = 1, EMPTY = 0, MAIN = 0, CRAFTS = 25, SPACE = 26,
	ASC = 0, DESC = 1, RANDOM = 2, NA = 0, SIZE = 2, MAX = 25, SECOND = 1, MIN = 2,
	UP1 = 5, UP2 = 6, UP3 = 7, UP4 = 8, ID = 0, X = 1, B = 8,
	SHOTGUN_COST = 0, BOUNDARY = 1, FAST_PANEL = 10,
	ITEM_OR_SLOT = 0, SAME_ITEM = 1, EMPTY_SLOT = 2 }
enum { R = 0, K = 1, RK = 3 }
enum { ARM, KNUCKLE, KNIFE, SWORD, RAPIER, GUN, RIFLE, LAUNCHER, DRONE, BOW, CROSSBOW, STAFF }

const aura: PackedByteArray = [10, 70,  0]
const resc: PackedByteArray = [10,  0, 50]

const power: PackedByteArray = [5, 5, 5, 5]
const shell: PackedByteArray = [5, 5, 5, 5]
const impac: PackedByteArray = [5, 5, 5, 5]
const react: PackedByteArray = [5, 5, 5, 5]

const equip: PackedByteArray = [R, R, K, K, R, R, R, K]
const types: PackedByteArray = [RAPIER, RAPIER, GUN, GUN]
const spend: PackedByteArray = [0, 0, 0, 0, 0, 1, 1, 3]

const cost: PackedFloat32Array = [0.33]

var product: PackedByteArray = [ETHER, ANTIDOTE, TEA, ANTICOUGH]
var recipe: PackedInt32Array = [
	WATER << B | TUMBLEWEED, WATER << B | OPUNTIA,
	WATER << B | TAMARISK, WATER << B | YUKKA]

var holder: Texture2D = null
var _image: TextureRect

var knuckle: PackedInt32Array = []
var sword: PackedInt32Array = []
var pistol: PackedInt32Array = []
var gun: PackedInt32Array = []
var heavy: PackedInt32Array = []
var armor: PackedInt32Array = []


var title: Array[HBoxContainer] = []
var size: int

var craft_mode: int
var crafting: PackedInt32Array = [0, 0, 0, 0]
var trade_slots: PackedByteArray = [0, 0]
var trade_bags: PackedByteArray = [0, 0]

var distraction: PackedInt32Array = []
var distraction_body: Array[StaticBody2D] = []
var _fast_panel: Tween
var icon: CompressedTexture2DArray

var crafts: int; var product_id: int = -1; var trade_mode: int = FULL

enum { SINGLE, HALF, FULL }
# CRAFT
enum { CRAFT_MODE, MODE_START, MODE_ITEMS, MODE_WEAPON, CRAFT_ID = 0, CRAFT_SLOT, CRAFTING, BAG = 1, NO_SLOT }

func distract() -> void: # LevelRoot
	var tile: PackedInt32Array = HUD.level.tile_at()
	for i in range(0, len(distraction)):
		if distraction[i] == tile[Def.COORDS]:
			distraction_body[i].add_stick()
			return
	var body: StaticBody2D
	distraction.append(0)
	distraction_body.append(body)

func store_water(slot: int) -> void:
	var tile: PackedInt32Array = HUD.level.tile_near()
	if tile[Def.ID] == ENTRY and tile[Def.ATLAS] == Def.D_WATER:
		produce_item(slot, WATER)

func update_ui(logic: Node, preview: Node, slots: Array) -> void:
	var ui: Node = logic.trade.ui
	ui.production()
	if preview.slots(logic, slots):
		ui.product(logic.item(preview.cells.craft_id))

func hide_selection() -> void:
	_fast_panel = HUD.create_tween()
	_fast_panel.tween_property(HUD.game.fast_panel, "modulate", Color.TRANSPARENT, 0.5)

func select_exact(slot: int) -> void:
	if _fast_panel.is_valid(): _fast_panel.kill()
	for item in get_fast_panel(selection): item.bar.back.hide()
	selection = slot
	for item in get_fast_panel(selection): item.bar.back.show()
	HUD.game.fast_panel.modulate = Color.WHITE
	HUD.item_select.start()

func select_shift(direction: int) -> void:
	select_exact(posmod(selection + direction, FAST_PANEL))

func update_inventory() -> void:
	for slot in range(len(storage) - 1, Def.INT, Def.INT):
		for ui in get_inventory(slot): ui_add_item(ui, slot)

func fast_panel_cost() -> int:
	match _id(slot):
		R_SCHO45, R_ENLIGHT: return HUD.get_stat(HUD.RESOURCE, HUD.hero)
		SHOTGUN: return HUD.get_stat(HUD.RESOURCE, HUD.hero) * cost[SHOTGUN_COST]
	return _count(slot)

func get_fast_panel() -> Array[Node]:
	match HUD.hero:
		Def.RAY: return [HUD.game.inventory.ray.slots[slot], HUD.game.priorities.ray.slots[slot], HUD.game.fast_panel]
		Def.ROCK: return [HUD.game.inventory.rock.slots[slot], HUD.game.priorities.rock.slots[slot], HUD.game.fast_panel]
	return []

func find_item(search: int, target_id: int = MISSING_NO) -> int:
	match search:
		ITEM_OR_SLOT:
			var slot: int = MISSING_NO
			for item in range(_offset(), _offset() + SLOTS):
				var count: int = _count(i)
				if slot == MISSING_NO and count == EMPTY: slot = item
				if _id(item) == target_id and count < LIMIT: return item
		SAME_ITEM:
			for item in range(_offset(), _offset() + SLOTS):
				if _id(item) == target_id: return item
		EMPTY_SLOT:
			for slot in range(_offset(), _offset() + SLOTS):
				if _count(slot) == EMPTY: return slot
	return MISSING_NO

func trade_item(from: int, bag_b: int, slot_b: int) -> void:
	if trade_slots[from] == NO_SLOT:
		trade_bags[from] = bag_b
		trade_slots[from] = slot_b
		return
	elif trade_slots[from] == slot_b and trade_bags[from] == bag_b:
		trade_slots[from] = NO_SLOT
		# use item if supported
		return
	
	var bag_a: int = trade_bags[from]
	var slot_a: int = trade_slots[from]
	
	var item_a: int = HUD.get_item(bag_a, slot_a)
	var item_b: int = HUD.get_item(bag_a, slot_a)
	HUD.set_item(bag_a, slot_a, item_b)
	HUD.set_item(bag_b, slot_b, item_a)
	show_item(bag_a, slot_a, Def.of_x(Def.BYTE, item_b, ID), 0, Def.of_x(Def.BYTE, item_b, X))
	show_item(bag_b, slot_b, Def.of_x(Def.BYTE, item_b, ID), 0, Def.of_x(Def.BYTE, item_a, X))

func put_item(bag: int, id: int) -> bool:
	var slot: int = find_item(ITEM_OR_SLOT, id) if id < USE else find_item(EMPTY_SLOT)
	if slot == MISSING_NO:
		HUD.game.markers.notify(HelpMarkers.STORAGE)
		return false # add logs message
	
	var item: int = HUD.get_item(HUD.hero, slot)
	var count: int = Def.of_x(Def.BYTE, item, X)
	item = id << Def.BYTE | count + 1
	show_item(bag, slot, id, count, count + 1)
	HUD.set_item(slot, item)
	return true

func show_item(bag: int, slot: int, id: int, previous: int, count: int) -> void:
	var name: StringName = &"ray" if bag == Def.RAY else &"rock"
	for item in [HUD.game.inventory.get(name).slots[slot], HUD.game.priorities.get(name).slots[slot]]:
		item.count.text = "" if count > 1 else str(count)
		if slot < FAST_PANEL: slot.bar.value = count
		if count == 0:
			item.image.texture = null
		elif previous == 0:
			item.image.texture = ImageTexture.create_from_image(icon.get_layer_data(id))

func open_door(id: int) -> void: pass
func use_boomerang(): pass

func produce_item(bag: int, slot: int, next: int) -> void:
	var item: int = HUD.get_item(HUD.hero, slot)
	if item == 0: return
	
	var id: int = Def.of_x(Def.BYTE, item, ID)
	var used: bool = false
	if WEAPON < id and id < KIT:
		match id:
			T_RAPIER, W_RAPIER: use_boomerang()
			T_RAPIER, W_RAPIER: use_boomerang()
			GOLD_KEY, SECRET_KEY: used = open_door(id)
	elif USE < id and id < ARMOR:
		var product_id: int = -1; 
		match id:
			JAR: if store_water(selection): used = put_item(bag, WATER)
			WATER:
				used = put_item(bag, JAR)
				if used:
					HUD.level.aura.add_points(HUD.hero, aura[id - USE])
					HUD.level.aura.add_resource(HUD.hero, resc[id - USE])
			TEA: used = put_item(bag, JAR); if used: HUD.level.aura.add_points(HUD.hero, aura[id - USE])
			ETHER: used = put_item(bag, JAR); if used: HUD.level.aura.add_resource(HUD.hero, resc[id - USE])
			ANTIDOTE: used = put_item(bag, JAR); if used: HUD.adversary.nullify(Adversary.POISON)
			ANTICOUGH: used = put_item(bag, JAR); if used: HUD.adversary.nullify(Adversary.COUGH)
			STICKS: used = true; distract()
	if used:
		var count: int = Def.of_x(Def.BYTE, item, X) - 1
		item = 0 if count == 0 else id << Def.BYTE | count
		HUD.set_item(bag, slot, item)
		show_item(bag, slot, id, count, count)

func craft_item(bag: int, slot: int) -> void:
	var item: int = HUD.get_item(bag, slot)
	if product_id == -1 or item != 0: return
	var name: StringName = &"ray" if bag == Def.RAY else &"rock"
	var id_a: int = Def.of_x(Def.BYTE, crafts, ID); var slot_a: int = -1
	var id_b: int = Def.of_x(Def.BYTE, crafts, X); var slot_b: int = -1
	for s in range(0, SLOTS):
		var i: int = HUD.get_item(bag, s)
		if slot_a == -1 and Def.of_x(Def.BYTE, i, ID) == id_a: slot_a = s
		if slot_b == -1 and Def.of_x(Def.BYTE, i, ID) == id_b: slot_b = s
		if slot_a != -1 and slot_b != -1: break
	if slot_a == -1 or slot_b == -1: return
	var count_a: int = Def.of_x(Def.BYTE, HUD.get_item(bag, slot_a), X)
	var count_b: int = Def.of_x(Def.BYTE, HUD.get_item(bag, slot_b), X)
	var next: int
	if count_a < count_b:
		next = count_a; count_b -= count_a; count_a = 0
	else:
		next = count_b; count_a -= count_b; count_b = 0
	HUD.set_item(bag, slot_a, id_a << Def.BYTE | count_a)
	HUD.set_item(bag, slot_b, id_b << Def.BYTE | count_b)
	HUD.set_item(bag, slot, product_id << Def.BYTE | next)
	show_item(bag, slot_a, id_a, count_a, count_a)
	show_item(bag, slot_b, id_b, count_b, count_b)
	show_item(bag, slot, product_id, 0, next)

func compatible(id: int) -> PackedInt32Array:
	if ARMOR < id and id < WEAPON:
		return armor
	else:
		return knuckle

func show_craft(bag: int) -> void:
	var name: StringName = &"ray" if bag == Def.RAY else &"rock"
	for type in [HUD.game.inventory.get(name), HUD.game.priorities.get(name)]:
		type.show()
		for i in range(0, 4):
			var slot: Control = type.craft[i]
			var id: int = Def.of_x(Def.BYTE, crafting[bag * CRAFTING + CRAFT_ID], i)
			slot.image.texture = null if id == 0 else ImageTexture.create_from_image(icon.get_layer_data(id - 1))
		type.result.texture = null if product_id == 0 else ImageTexture.create_from_image(icon.get_layer_data(product_id - 1))

func craft_product(bag: int, slot: int) -> void:
	var min_count: int = 30
	var limit: int = -1
	var next: Vector2i = _slot(bag)
	for i in range(3, -1, -1):
		var id: int = Def.of_x(Def.BYTE, crafting[next[CRAFT_ID]], i)
		if id == 0: continue
		elif limit == -1: limit = i
		
		var s: int = Def.of_x(Def.BYTE, crafting[next[CRAFT_SLOT]], i)
		var count: int = Def.of_x(Def.BYTE, HUD.get_item(bag, s), i)
		if count < min_count: min_count = count
	var name: StringName = &"ray" if bag == Def.RAY else &"rock"
	for i in range(0, limit):
		var s: int = Def.of_x(Def.BYTE, crafting[next[CRAFT_SLOT]], i)
		var item: Vector2i = bag_slot(HUD.get_item(bag, s))
		show_item(bag, s, item[ID], item[X], item[X] - min_count)
		HUD.set_item(bag, s, item[ID] << Def.BYTE | item[X] - min_count)
		for a in [HUD.game.inventory.get(name).slots[s], HUD.game.priorities.get(name).slots[s]]:
			a.show()
	HUD.set_item(bag, slot, min_count << Def.BYTE | product_id)
	show_item(bag, slot, product_id, 0, min_count)
	crafting[next[CRAFT_ID]] = 0
	crafting[next[CRAFT_SLOT]] = 0
	product_id = 0
	show_craft(bag)

func add_slot(bag: int, slot: int) -> void:
	var item: int = HUD.get_item(bag, slot)
	var id: int = Def.of_x(Def.BYTE, item, ID)
	var mode: int = Def.of_x(Def.MASK, craft_mode, HUD.hero)
	if mode == MODE_START:
		if (BAG_START <= id and id < ARMOR) or (KIT <= id and id < BAG_END):
			mode = MODE_ITEMS
			product_id = 0
		else:
			mode = MODE_WEAPON
			product_id = id
			show_craft(bag)
		craft_mode = Def.to_x(Def.MASK, craft_mode, HUD.hero, mode)
	if mode == MODE_ITEMS and (BAG_START <= id and id < ARMOR):
		var next: Vector2i = _slot(bag)
		if item == 0 and product_id != 0:
			craft_product(bag, slot); return
		elif Def.of_x(Def.BYTE, crafting[next[CRAFT_ID]], 3) != 0:
			crafting[next[CRAFT_ID]] = 0
			crafting[next[CRAFT_SLOT]] = 0
		crafting[next[CRAFT_ID]] = crafting[next[CRAFT_ID]] << Def.BYTE | id
		crafting[next[CRAFT_SLOT]] = crafting[next[CRAFT_SLOT]] << Def.BYTE | slot
		for i in range(0, len(trade_bags)):
			if i != bag and trade_bags[i] == bag:
				trade_bags[i] = 0
				trade_slots[i] = 0
		
		var name: StringName = &"ray" if bag == Def.RAY else &"rock"
		for s in [HUD.game.inventory.get(name).slots[slot], HUD.game.priorities.get(name).slots[slot]]:
			s.hide()
		product_id = 0
		for material in recipe:
			if crafting[next[CRAFT_ID]] & material == material:
				product_id = product[material]
				break
		show_craft(bag)
	elif mode == MODE_WEAPON and KIT < id and id < BAG_END:
		var cell: Vector2i = _slot(bag)
		var next: Vector2i = Vector2i(crafting[cell[CRAFT_ID]] << Def.BYTE | id, crafting[cell[CRAFT_SLOT]] << Def.BYTE | slot)
		var kit: PackedInt32Array = compatible(id)
		for type in kit:
			if type & next[CRAFT_ID] == type:
				crafting[cell[CRAFT_ID]] = next[CRAFT_ID]
				crafting[cell[CRAFT_SLOT]] = next[CRAFT_SLOT]
				show_craft(bag)
				HUD.set_item(bag, slot, 0)
				show_item(bag, slot, next[CRAFT_ID], 1, 0)
				return
		# toggle red
		
func bag_slot(item: int) -> Vector2i:
	return Vector2i(Def.of_x(Def.BYTE, item, ID), Def.of_x(Def.BYTE, item, X))
	
func _slot(bag: int) -> Vector2i: return bag * CRAFTING * Vector2i.ONE + Vector2i(CRAFT_ID, CRAFT_SLOT)

func _bag(type: int) -> int: return HUD.hero * CRAFTING + type

func _craft(bag: int) -> bool:
	var mode: int = Def.of_x(Def.MASK, crafting[CRAFT_MODE], _bag(CRAFT_MODE))
	mode = MODE_START if mode == CRAFT_MODE else CRAFT_MODE
	crafting[CRAFT_MODE] = Def.to_x(Def.MASK, crafting[CRAFT_MODE], _bag(CRAFT_MODE), mode)
	var slot: Vector2i = _slot(bag)
	crafting[slot[CRAFT_ID]] = 0
	crafting[slot[CRAFT_SLOT]] = 0
	# toggle slots

func select_item(view: Control) -> void:
	if Def.of_x(Def.MASK, crafting[CRAFT_MODE], _bag(CRAFT_MODE)) == CRAFT_MODE:
		trade_item(HUD.hero, view.bag, view.slot)
	else:
		add_slot(view.bag, view.slot)

func _input(e: InputEvent) -> void:
	if (e is InputEventMouseButton and (e.button_index == MOUSE_BUTTON_LEFT) and e.is_released()):
		reset_texture(_image)

func reset_texture(image: TextureRect) -> void:
	if holder != null:
		image.texture = holder
		holder = null

func get_preview_rect() -> TextureRect:
	var image: TextureRect = TextureRect.new()
	image.texture = holder
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.size = Vector2.ONE * PREVIEW_SIZE
	image.position -= PREVIEW_SIZE / 2
	return image

func set_preview(cell: CellDrag) -> CellDrag:
	_image = cell.image
	holder = cell.image.texture
	var preview: Control = Control.new()
	preview.add_child(get_preview_rect())
	cell.image.set_drag_preview(preview)
	cell.image.texture = null
	return cell
