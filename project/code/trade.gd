class_name Trades extends RefCounted
enum {
# ITEMS
	STICKS, OPUNTIA, TUMBLEWEED, TAMARISK, YUKKA, JAR, ANTIDOTE, ANTICOUGH,
	GOLD_KEY, SECRET_KEY, WATER, TEA, ETHER, L_PANTS, I_PANTS, L_ARMOR, I_ARMOR,
	L_BOOTS, I_BOOTS, SHIELD, CORETOOTH, KNUCKLES, SAW_STRING, W_RAPIER, T_RAPIER,
	SHOE, R_SCHO45, R_ENLIGHT, SHOTGUN, BOOMERANG, BUTTER, F_BUTTER, CLEANER,
	SHARPEN, AMMO, BLADE, PUMP, AIM, MISSING_NO,
# ITEM TYPES
	B_START = 0, CRAFT = 7, USE = 10, ARMOR = 20, WEAPON = 28, KIT = 36, B_END = 50,
# LIMITS
	FAST_PANEL = 5, SLOTS = 15, LIMIT = 30, LIMIT_CRAFT = 2, PREVIEW_SIZE = 72,
# SPECIAL SLOTS
	WEAPON_SLOT = 11, ARTIFACT_SLOT, ARMOR_SLOT, LEG_SLOT, FOOT_SLOT, NO_SLOT = -1,
	SPECIAL_SLOTS = (1<<WEAPON_SLOT)|(1<<ARTIFACT_SLOT)|(1<<ARMOR_SLOT)|(1<<LEG_SLOT)|(1<<FOOT_SLOT),
# SORTING
	AURA = 0, RESOURCE = 1, AR = 2, ID = 0, X = 1, SLOT = 1, B = 8,
	UP1 = 5, UP2 = 6, UP3 = 7, UP4 = 8, NA = 0, SIZE = 2, SECOND = 1, MIN = 2,
# MISC
	BAG = 6, BSLOT = 63, ITEMS = 0, UNIT = 1, EMPTY = 0, MAIN = 0, CRAFTS = 25, SPACE = 26,
# RESOURCE COST
	SHOTGUN_COST = 0, BOUNDARY = 1,
# SEARCH, SORT & TRADE
	ITEM_OR_SLOT = 0, SAME_ITEM, EMPTY_SLOT, SINGLE = 0, HALF, FULL, ASC = 0,
	DESC, RANDOM, CRAFT_MODE = 0, MODE_START, MODE_ITEMS, MODE_WEAPON,
# WEAPON TYPE
	ARM = 0, KNUCKLE, KNIFE, SWORD, RAPIER, GUN, RIFLE, LAUNCHER, DRONE, BOW,
	CROSSBOW, STAFF,
# HERO ABLE
	R = 0, K = 1, RK = 3
}
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
	WATER<<B | TUMBLEWEED, WATER<<B | OPUNTIA,
	WATER<<B | TAMARISK, WATER<<B | YUKKA]

var holder: Texture2D = null
var _image: TextureRect

var knuckle: PackedInt32Array = []
var sword: PackedInt32Array = []
var pistol: PackedInt32Array = []
var gun: PackedInt32Array = []
var heavy: PackedInt32Array = []
var armor: PackedInt32Array = []

var crafting: PackedInt32Array = [0, 0, 0, 0]
var product_id: int = -1

var distraction: PackedInt32Array = [0, 0]
# var _fast_panel: Tween
var icon: CompressedTexture2DArray

const BUSY: String = "Storage is full"

enum { NO_ITEM, ITEM_USED, ITEM_THROW, WEAPON_THROW,
	THROW_RAPIER = (1<<T_RAPIER)|(1<<W_RAPIER),
	KEYS_ID = (1<<GOLD_KEY)|(1<<SECRET_KEY) }

func distract(bag: int) -> void: # LevelRoot
	var tile: PackedInt32Array = HUD.level.tile_at()
	if distraction[bag] == tile[HUD.COORDS]:
		HUD.level.distraction_body[bag].add_stick()
		return
	#var body: StaticBody2D
	distraction[bag] = 0
	#distraction_body[bag] = body

func produce_item(bag: int, slot: int) -> int:
	var item: int = HUD.get_item(bag, slot)
	if item == 0: return NO_ITEM
	
	var id: int = D.byte(item, ID)
	var used: bool = false
	if WEAPON < id and id < KIT:
		if D.of(THROW_RAPIER, id): return WEAPON_THROW
		elif id == GOLD_KEY: used = HUD.level.action.open_door(bag); if used: HUD.level.set_tile(HUD.GROUND) # TODO check if it actual ground tile
		elif id == SECRET_KEY: used = HUD.level.action.open_secret(bag); if used: HUD.level.set_tile(HUD.GROUND) # TODO check if it actual ground tile
	elif USE < id and id < ARMOR:
		match id:
			JAR: if HUD.level.action.near_water(): used = put_item(bag, WATER)
			WATER:
				used = put_item(bag, JAR)
				if used:
					HUD.level.aura.add_points(bag, aura[id - USE])
					HUD.level.aura.add_resource(bag, resc[id - USE])
			TEA: used = put_item(bag, JAR); if used: HUD.level.aura.add_points(bag, aura[id - USE])
			ETHER: used = put_item(bag, JAR); if used: HUD.level.aura.add_resource(bag, resc[id - USE])
			ANTIDOTE: used = put_item(bag, JAR); if used: HUD.adversary.nullify(Adversary.POISON)
			ANTICOUGH: used = put_item(bag, JAR); if used: HUD.adversary.nullify(Adversary.COUGH)
			STICKS: used = true; distract(bag)
	if used:
		var count: int = D.byte(item, X) - 1
		item = 0 if count == 0 else id << D.BYTE | count
		HUD.set_item(bag, slot, item)
		show_item(bag, slot, id, count, count)
	return ITEM_USED

func update_ui(logic: Node, preview: Node, slots: Array) -> void:
	var ui: Node = logic.trade.ui
	ui.production()
	if preview.slots(logic, slots):
		ui.product(logic.item(preview.cells.craft_id))

func fast_panel_cost(hero: int) -> int:
	match D.byte(HUD.get_item(hero, HUD.has(D.FAST_PANEL | hero)), ID):
		SHOTGUN: return int(HUD.get_stat(HUD.RESOURCE, hero) * cost[SHOTGUN_COST])
	return HUD.get_stat(HUD.RESOURCE, hero)

func update_inventory(bag: int) -> void:
	for slot in range(24, -1, -1):
		for ui in _get_ui(bag):
			var item: Vector2i = D.short_of(HUD.get_item(bag, slot))
			show_item(bag, slot, item[ID], item[X], item[X])

func find_item(bag: int, search: int, target_id: int = MISSING_NO) -> int:
	match search:
		ITEM_OR_SLOT:
			var result: int = MISSING_NO
			for slot in range(0, SLOTS):
				var item: Vector2i = D.short_of(HUD.get_item(bag, slot))
				if result == MISSING_NO and item[X] == EMPTY: result = slot
				if item[ID] == target_id and item[X] < LIMIT: return result
		SAME_ITEM:
			for slot in range(0, SLOTS):
				if D.byte(HUD.get_item(bag, slot), ID) == target_id: return slot
		EMPTY_SLOT:
			for slot in range(0, SLOTS):
				if D.byte(HUD.get_item(bag, slot), X) == EMPTY: return slot
	return MISSING_NO

func trade_item(from: int, bag_b: int, slot_b: int) -> void:
	if D.part(HUD.has(D.CRAFT_MODE), bag_b) != CRAFT_MODE:
		add_slot(bag_b, slot_b); return
	var b: int = HUD.has(D.TRADE_BAGS | from); var next: int = bag_b << BAG | slot_b
	if b == NO_SLOT:
		HUD.having(D.TRADE_BAGS | from, next); return
	elif b == next:
		HUD.having(D.TRADE_BAGS | from, NO_SLOT); return # use item if supported
	
	var bag_a: int = HUD.has(D.TRADE_BAGS | from) >> BAG
	var slot_a: int = HUD.has(D.TRADE_BAGS | from) & BSLOT
	
	var item_a: int = HUD.get_item(bag_a, slot_a)
	var item_b: int = HUD.get_item(bag_a, slot_a)
	HUD.set_item(bag_a, slot_a, item_b)
	HUD.set_item(bag_b, slot_b, item_a)
	show_item(bag_a, slot_a, D.byte(item_b, ID), 0, D.byte(item_b, X))
	show_item(bag_b, slot_b, D.byte(item_b, ID), 0, D.byte(item_a, X))

func put_item(bag: int, id: int) -> bool:
	var slot: int = find_item(bag, ITEM_OR_SLOT, id) if id < USE else find_item(bag, EMPTY_SLOT)
	if slot == MISSING_NO:
		HUD.timing.add_log(BUSY)
		return false # add logs message
	
	var item: int = HUD.get_item(bag, slot)
	var count: int = D.byte(item, X)
	show_item(bag, slot, id, count, count + 1)
	HUD.set_item(bag, slot, id << D.BYTE | count + 1)
	return true

func show_item(bag: int, slot: int, id: int, previous: int, count: int) -> void:
	for ui in _get_ui(bag):
		var item: Control = ui.slots[slot]
		item.count.text = "" if count > 1 else str(count)
		if slot < FAST_PANEL: item.bar.value = count
		if count == 0:
			item.image.texture = null
		elif previous == 0:
			item.image.texture = ImageTexture.create_from_image(icon.get_layer_data(id))

func craft_item(bag: int, slot: int) -> void:
	var item: int = HUD.get_item(bag, slot)
	if product_id == -1 or item != 0: return

	var id_a: int = HUD.byte(D.CRAFT | bag, 0); var slot_a: int = HUD.byte(D.CRAFT | bag, SLOT)
	var id_b: int = HUD.byte(D.CRAFT | bag, 1); var slot_b: int = HUD.byte(D.CRAFT | bag, SLOT | 1)
	if !(D.byte(HUD.get_item(bag, slot_a), ID) == id_a and D.byte(HUD.get_item(bag, slot_b), ID) == id_b):
		slot_a = -1; slot_b = -1
		for s in range(0, SLOTS):
			var i: int = HUD.get_item(bag, s)
			if slot_a == -1 and D.byte(i, ID) == id_a: slot_a = s
			if slot_b == -1 and D.byte(i, ID) == id_b: slot_b = s
			if slot_a != -1 and slot_b != -1: break
		if slot_a == -1 or slot_b == -1: return
	var count_a: int = D.byte(HUD.get_item(bag, slot_a), X)
	var count_b: int = D.byte(HUD.get_item(bag, slot_b), X)
	var next: int
	if count_a < count_b:
		next = count_a; count_b -= count_a; count_a = 0
	else:
		next = count_b; count_a -= count_b; count_b = 0
	HUD.set_item(bag, slot_a, id_a << D.BYTE | count_a)
	HUD.set_item(bag, slot_b, id_b << D.BYTE | count_b)
	HUD.set_item(bag, slot, product_id << D.BYTE | next)
	show_item(bag, slot_a, id_a, count_a, count_a)
	show_item(bag, slot_b, id_b, count_b, count_b)
	show_item(bag, slot, product_id, 0, next)

func _get_ui(bag: int) -> Array[Control]:
	var name: StringName = &"ray" if bag == D.RAY else &"rock"
	return [HUD.game.inventory.get(name), HUD.game.priorities.get(name)]

func _craft(type: int, slot: int) -> int: return D.byte(crafting[type], slot)

func compatible(id: int) -> PackedInt32Array:
	if ARMOR < id and id < WEAPON:
		return armor
	else:
		return knuckle

func show_craft(bag: int) -> void:
	for type in _get_ui(bag):
		type.show()
		for i in range(0, LIMIT_CRAFT):
			var slot: Control = type.craft[i]
			var id: int = HUD.byte(D.CRAFT | bag, i)
			slot.image.texture = null if id == 0 else ImageTexture.create_from_image(icon.get_layer_data(id - 1))
		type.result.texture = null if product_id == 0 else ImageTexture.create_from_image(icon.get_layer_data(product_id - 1))

func craft_product(bag: int, slot: int) -> void:
	var min_count: int = 30
	var limit: int = -1
	var next: Vector2i = _slot(bag)
	for i in range(3, -1, -1):
		var id: int = _craft(next[ID], i)
		if id == 0: continue
		elif limit == -1: limit = i
		
		var s: int = _craft(next[SLOT], i)
		var count: int = D.byte(HUD.get_item(bag, s), i)
		if count < min_count: min_count = count
	for i in range(0, limit):
		var s: int = _craft(next[SLOT], i)
		var item: Vector2i = D.short_of(HUD.get_item(bag, s))
		show_item(bag, s, item[ID], item[X], item[X] - min_count)
		HUD.set_item(bag, s, item[ID] << D.BYTE | item[X] - min_count)
		for ui in _get_ui(bag): ui.slots[s].show()
	HUD.set_item(bag, slot, min_count << D.BYTE | product_id)
	show_item(bag, slot, product_id, 0, min_count)
	crafting[next[ID]] = 0
	crafting[next[SLOT]] = 0
	product_id = 0
	show_craft(bag)

func add_slot(bag: int, slot: int) -> void:
	var item: int = HUD.get_item(bag, slot)
	var id: int = D.byte(item, ID)
	var mode: int = D.part(HUD.has(D.CRAFT_MODE), bag)
	if mode == MODE_START:
		if (B_START <= id and id < ARMOR) or (KIT <= id and id < B_END):
			mode = MODE_ITEMS
			product_id = 0
		else:
			mode = MODE_WEAPON
			product_id = id
			show_craft(bag)
		HUD.having(D.CRAFT_MODE, D.to_part(HUD.has(D.CRAFT_MODE), bag, mode))
	if mode == MODE_ITEMS and (B_START <= id and id < ARMOR):
		if item == 0 and product_id != 0:
			craft_product(bag, slot); return
		elif D.byte(HUD.number(D.CRAFT | bag, 0), 3) != 0:
			HUD.hasnt(D.CRAFT | bag)
		var nid: int = HUD.number(D.CRAFT | bag, 0) << D.BYTE | id
		var nslot: int = HUD.number(D.CRAFT | bag, 1) << D.BYTE | slot
		HUD.give(D.CRAFT | bag, nid << D.INTEGER | nslot)
		for i in range(0, D.PARTY):
			if i != bag and D.m(HUD.has(D.TRADE_BAGS | i), bag << BAG):
				HUD.hasnt(D.TRADE_BAGS | i)
		
		for ui in _get_ui(bag): ui.slots[slot].hide()
		product_id = 0
		for material in recipe:
			if D.m(nid, material):
				product_id = product[material]
				break
		show_craft(bag)
	elif mode == MODE_WEAPON and KIT < id and id < B_END:
		var nid: int = HUD.number(D.CRAFT | bag, 0)
		var next: int
		if item == 0:
			# HUD.has(D.CRAFT)
			if nid == 0: return
			next = D.byte(nid, 0)

			HUD.set_item(bag, slot, next << D.BYTE)
			show_item(bag, slot, next, 0, 1)
			nid >>= D.BYTE
			HUD.to_number(D.CRAFT | bag, 0, nid)
			return

		next = nid << D.BYTE | id
		var kit: PackedInt32Array = compatible(id)
		for i in range(0, len(kit)):
			if D.m(next, kit[i]):
				nid = next
				HUD.to_number(D.CRAFT | bag, 0, nid)
				show_craft(bag)
				HUD.set_item(bag, slot, 0)
				show_item(bag, slot, next, 1, 0)
				return
		# toggle red

func reset_holder() -> void: reset_texture(_image)
func reset_texture(image: TextureRect) -> void:
	if holder != null:
		image.texture = holder
		holder = null

func set_preview(cell: Control) -> Control:
	_image = cell.image
	holder = cell.image.texture
	var preview: TextureRect = TextureRect.new()
	preview.texture = holder
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = Vector2.ONE * PREVIEW_SIZE
	preview.position -= Vector2.ONE * (PREVIEW_SIZE >> 1)
	cell.image.set_drag_preview(preview) # add control as root if not work
	cell.image.texture = null
	return cell

func set_marker(hero: int, before: int, after: int) -> void:
	HUD.main_items[hero][before].remove_child(HUD.markers[hero])
	HUD.main_items[hero][after].add_child(HUD.markers[hero])

func fast_panel_swap(hero: int, offset: int) -> void:
	var before: int = HUD.has(D.FAST_PANEL | hero)
	var result: int = before + offset
	if result > FAST_PANEL:
		HUD.having(D.FAST_PANEL | hero, 0)
	elif result < 0:
		HUD.having(D.FAST_PANEL | hero, FAST_PANEL - 1)
	else:
		var target: Vector2i = Vector2i(0, -1) if offset < 0 else Vector2i(FAST_PANEL - 1, FAST_PANEL)
		for i in range(HUD.has(D.FAST_PANEL | hero) + offset, target.y, offset):
			if i == target.x or HUD.get_item(hero, i) != 0:
				HUD.having(D.FAST_PANEL | hero, i)
				if HUD.inventory_scroll != null:
					set_marker(hero, before, i)
				break

func fast_panel_select(hero: int, slot: int) -> void:
	var before: int = HUD.has(D.FAST_PANEL | hero)
	if slot == before: return
	elif slot == FAST_PANEL:
		HUD.having(D.FAST_PANEL | hero, slot); return
	var result: int = 0
	for i in range(0, FAST_PANEL):
		if HUD.get_item(hero, slot) != 0:
			result += 1; continue
		if result == slot:
			result = i; break
	if result == slot:
		HUD.having(D.FAST_PANEL | hero, result)
		if HUD.inventory_scroll != null:
			set_marker(hero, before, result)
