class_name HeroInventory extends RefCounted

enum { STICKS, OPUNTIA, TUMBLEWEED, TAMARISK, YUKKA, JAR, ANTIDOTE, ANTICOUGH, GOLD_KEY, SECRET_KEY,
	WATER, TEA, ETHER, L_PANTS, I_PANTS, L_ARMOR, I_ARMOR, L_BOOTS, I_BOOTS,
	SHIELD, CORETOOTH, KNUCKLES, SAW_STRING, W_RAPIER, T_RAPIER, SHOE, R_SCHO45,
	R_ENLIGHT, SHOTGUN, BOOMERANG, BUTTER, F_BUTTER, CLEANER, SHARPEN, AMMO,
	BLADE, PUMP, AIM, MISSING_NO, SLOTS = 25, LIMIT = 30, CRAFT = 7, USE = 10, LIMIT_CRAFT = 2,
	ARMOR = 20, WEAPON = 28, KIT = 36, AURA = 0, RESOURCE = 1, AR = 2, CROSS = 2, BOTH = 3,
	PREVIEW_SIZE = 72, ITEMS = 0, SLOT = 1, UNIT = 1, EMPTY = 0, MAIN = 0, CRAFTS = 25, SPACE = 26,
	ASC = 0, DESC = 1, RANDOM = 2, NA = 0, SIZE = 2, MAX = 25, SECOND = 1, MIN = 2,
	UP1 = 5, UP2 = 6, UP3 = 7, UP4 = 8, ID = 0, X = 1,
	SHOTGUN_COST = 0, BOUNDARY = 1, FAST_PANEL = 10,
	ITEM_OR_SLOT = 0, SAME_ITEM = 1, EMPTY_SLOT = 2 }

const aura: PackedByteArray = [10, 70,  0]
const resc: PackedByteArray = [10,  0, 50]

const power: PackedByteArray = [5, 5, 5, 5]
const shell: PackedByteArray = [5, 5, 5, 5]
const impac: PackedByteArray = [5, 5, 5, 5]
const react: PackedByteArray = [5, 5, 5, 5]

const equip: PackedByteArray = [Def.RAY, Def.RAY, Def.ROCK, Def.ROCK, Def.RAY,
	Def.RAY, Def.RAY, Def.ROCK]
const cross: PackedByteArray = [W_RAPIER, T_RAPIER, R_SCHO45, R_ENLIGHT]
const spend: PackedByteArray = [0, 0, 0, 0, 0, 1, 1, 3]

var storage: PackedInt64Array
var _jars: Dictionary = { "a": [6, 8, 10], "h": [1, 2, 6, 7, 9, 11, 12] }
var items: GameItems
var inventory: Array = []
var slots: TradeSlots

var ii: int
var craft: Dictionary
var craft_id: int = Def.INT
var _recipes: Array = Def.ARRAY
var selection: Array[Dictionary] = [_cursor(), _cursor()]
var main: Dictionary:
	get: return selection[MAIN]
var holder: Texture2D = null
var _image: TextureRect

var distraction: PackedInt32Array = []
var distraction_body: Array[StaticBody2D] = []

func _init() -> void:
	storage = [0]
	storage.resize(SLOTS * Def.PARTY)

func use_inventory(id: int) -> void:
	match id:
		JAR: store_water(selection)
		WATER, TEA, ETHER: refill(aura[id - USE], resc[id - USE])
		ANTIDOTE: HUD.game.level.status.nullify(GameStatuses.POISON)
		ANTICOUGH: HUD.game.level.status.nullify(GameStatuses.COUGH)
		STICKS: distract()
		T_RAPIER, W_RAPIER: use_boomerang() ; return false
		T_RAPIER, W_RAPIER: use_boomerang() ; return false
		GOLD_KEY, SECRET_KEY: open_door(id) ; return false
		_: return false
	return true

func open_door(id: int) -> void: pass

func use_boomerang(): pass

func refill(hp: int, ap: int) -> void:
	if hp != 0: HUD.level.aura.add_points(HUD.hero, hp)
	if ap != 0: HUD.level.aura.add_resource(HUD.hero, ap)

func distract() -> void: # LevelRoot
	var tile: PackedInt32Array = HUD.level.tile_at()
	for i in range(0, len(distraction)):
		if distraction[i] == tile[Def.COORDS]:
			distraction_body[i].add_stick()
			return
	var body: StaticBody2D
	distraction.append()
	distraction_body.append(body)

func store_water(slot: int) -> void:
	var tile: PackedInt32Array = HUD.level.tile_near()
	if tile[Def.ID] == ENTRY and tile[Def.ATLAS] == Def.D_WATER:
		produce_item(slot, WATER)

func i(hero: int, no: int) -> int: return hero * Def.PARTY + no

func switch_bags(a: int, b: int) -> void:
	var i: int = i(HUD.hero, a)
	storage[i(HUD.next(), b)] = value
	storage[i] = EMPTY
	for j in [[items, a], [hero, b]]:
		j[ITEMS].ui.update_item(j[SLOT], j[ITEMS].storage[j[SLOT]])

func update_ui(logic: Node, preview: Node, slots: Array) -> void:
	var ui: Node = logic.trade.ui
	ui.production()
	if preview.slots(logic, slots):
		ui.product(logic.item(preview.cells.craft_id))

var _fast_panel: Tween

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

func ui_drop_item(slot: Button, no: int) -> void:
	slot.image.texture = null
	slot.number.text = ""
	if no < FAST_PANEL: slot.bar.value = 0

func ui_add_item(slot: Button, no: int) -> void:
	var i: int = i(HUD.hero, no)
	var count: int = _count(i)
	slot.image.texture = _get_icon(_id(i))
	if no < FAST_PANEL: slot.bar.value = count
	slot.number.text = str(count)

func ui_count_item(slot: Button, count: int) -> void:
	if count == BOUNDARY: slot.image.texture = null
	slot.number.text = "" if count <= BOUNDARY else str(next)
	if no < FAST_PANEL: slot.bar.value = next

func update_inventory() -> void:
	for slot in range(len(storage) - 1, Def.INT, Def.INT):
		for ui in get_inventory(slot): ui_add_item(ui, slot)


const cost: PackedFloat32Array = [0.33]

func fast_panel_cost() -> int:
	match _id(slot):
		R_SCHO45, R_ENLIGHT: return HUD.level.aura.resource(HUD.hero)
		SHOTGUN: return HUD.level.aura.resource(HUD.hero) * cost[SHOTGUN_COST]
	return _count(slot)

func get_fast_panel() -> Array[Node]:
	match HUD.hero:
		Def.RAY: return [HUD.game.inventory.ray.slots[slot], HUD.game.priorities.ray.slots[slot], HUD.game.fast_panel]
		Def.ROCK: return [HUD.game.inventory.rock.slots[slot], HUD.game.priorities.rock.slots[slot], HUD.game.fast_panel]
	return []

func get_inventory(slot: int) -> Array[Node]:
	match HUD.hero:
		Def.RAY: return [HUD.game.inventory.ray.slots[slot], HUD.game.priorities.ray.slots[slot]]
		Def.ROCK: return [HUD.game.inventory.rock.slots[slot], HUD.game.priorities.rock.slots[slot]]
	return []

func _count(no: int) -> int: return Bit.of_x(Bit.SHORT, storage[no], X)
func _id(no: int) -> int: return Bit.of_x(Bit.SHORT, storage[no], ID)
func _offset() -> int: return SLOTS * HUD.hero

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

func produce_item(source: int, product_id: int) -> void:
	var product: int = find_item(ITEM_OR_SLOT, product_id)
	if product != MISSING_NO:
		use_item(source)
		put_item(product, product_id)
	else:
		HUD.game.markers.notify(HelpMarkers.STORAGE)

func store_new_item(id: int) -> int:
	var slot: int = find_item(SAME_ITEM, id) if id < USE else find_item(EMPTY_SLOT)
	if slot != MISSING_NO: put_item(slot, id)
	return slot

func use_item(slot: int) -> void: # use_inventory
	var i: int = i(HUD.hero, slot)
	if use_inventory(_id(i)): return
	if _count(i) < 1: return
	storage[i] = Bit.edit_x(Bit.SHORT, storage[i], X, -1)
	for ui in get_inventory(slot): ui_count_item(ui, _count(slot))

func add_item(slot: int) -> void:
	var i: int = i(HUD.hero, slot)
	storage[i] = Bit.edit_x(Bit.SHORT, storage[i], X, +1)
	for ui in get_inventory(slot): ui_add_item(ui, slot)

func put_item(slot: int, id: int, count: int = 1) -> void:
	var i: int = i(HUD.hero, slot)
	storage[i] = count << Bit.SHORT | id
	add_item(slot)





func remember(id: int) -> void: # func find(id: int) -> void: status.hero.to.chats.log.add_item(bank.get_item(id).item.name)
	status.log.add_item(logic.item(id).item.name) #; print("REMEMBER ITEM NO = ", no)

func reload_resource() -> void:
	pass





func fillable(cell: Variant, key: String) -> bool:
	return cell.drag.ui.get_slot(cell.slot).id in _jars[key]

func _logic(item: Dictionary, s: Dictionary) -> int:
	return item.item.logic.get(s.key)

func get_item(i: int) -> Dictionary:
	return effect.logic.item(items.storage[i].id)

func more(a: int, b: int) -> bool: return a >= b
func desc_sort(cond: bool) -> int: return Sort.DESC if cond else Sort.RANDOM

func determine_sort(p: int, n: int, s: Dictionary) -> void:
	match s.sort:
		Sort.ASC: if not p <= n: s.sort = desc_sort(s.size == SIZE and more(p, n))
		Sort.DESC: if not more(p, n): s.sort = Sort.RANDOM

func _no_use(l: IUse, s: Dictionary, i: int) -> bool:
	return l.get(s.key) == NA or items.storage[i].x <= NA

func add_usable(s: Dictionary, i: int) -> void:
	var it: Dictionary = get_item(i)
	if it.logic is not IUse or _no_use(it.logic, s, i): return
	
	s.result.append({ "slot": i, "item": it })
	s.size += 1
	
	if s.size >= SIZE:
		determine_sort(_logic(s.result[i - 1], s), it.logic.get(s.key), s)

func use_as_slot(slot: int) -> int:
	return use_item({ "slot": slot, "item": get_item(slot) })

func _usage(s: Dictionary, p: Node, condition: Callable) -> int:
	var previous: Dictionary = s.result.front()
	for item in s.result:
		if condition.call(p.points + _logic(item, s), p.maximum):
			return use_item(previous)
		previous = item
	return use_item(previous)

func _sort_usage(s: Dictionary, p: Node) -> int:
	print("Sort is defined as: ", s.sort)
	match s.sort: # Only after sort found
		Sort.ASC: return _usage(s, p, more)
		Sort.DESC: return _usage(s, p, func(a, b): return a < b)
	return use_item(s.result.pick_random())

func _usables_search(key: String, p: Node) -> int:
	if p.points == p.maximum:
		HUD.game.markers.notify(HelpMarkers.IS_FULL)
		return -1
	
	var s: Dictionary = { "result": [], "size": 0, "sort": Sort.ASC, "key": key }
	for i in range(0, MAX): add_usable(s, i)
	match s.size:
		0: return 0
		1: return use_item(s.result.front())
		_: return _sort_usage(s, p)

func quick_heal() -> void:
	_usables_search("power", effect.status.hero.to.stats.health.points)

func reload_resource() -> void:
	_usables_search("supply", effect.status.hero.to.stats.aura)


func set_logic(logic: Node) -> void:
	placement.preview = preview

func add_slot(slot: int) -> void:
	slots.operate("craft", LIMIT_CRAFT, placement.make_slot(slot))
	workspace.update_ui(placement.search.logic, preview, slots.slots)

func one_item(selected: Dictionary) -> void: pass
func one_slot(slot: int) -> bool:
	placement.search.put_product(slots.slots, preview.cells.craft_id, slot)
	reset()
	return true

func reset() -> void:
	slots.reload()
	placement.search.logic.trade.ui.production()

func all_items() -> void: pass

func product() -> void: placement.craft(slots.slots)



func _has_first(items: Array) -> bool:
	return cells.check(cells.recipe(items), cells.first, cells.set_id, 0)

func _has_other(items: Array) -> bool:
	return cells.check(items, cells.other, Def.FUNC, cells.MIN)

func reset_id() -> bool:
	cells.set_id(Def.INT)
	return false

func complete_product(logic: Node, items: Array) -> bool:
	if cells.matches(logic, items): return true
	return reset_id()

func slots(logic: Node, items: Array) -> bool:
	if items.size() < cells.MIN: return false
	
	if not _has_first(items): return reset_id()
	if items.size() == cells.MIN: return complete_product(logic, items)
	
	if not _has_other(items): return reset_id()
	return complete_product(logic, items)


func check(items: Array, search: Callable, flow: Callable, offset: int) -> bool:
	for i in range(offset, len(items)):
		if search.call(items, i):
			ii = items[i]
			flow.call(craft[ii].o)
			return true
	return false

func matches(_logic: Node, items: Array) -> bool:
	#var products: Dictionary = logic.items.items.crafting.craft
	#logic.item(craft_id).item.craft.o
	return craft[ii].i.size() == items.size()

func first(items: Array, i: int) -> bool: return items[i] in _recipes

func other(items: Array, i: int) -> bool:
	return craft_id in _craft(items[i]).o

func set_id(id: int) -> void: craft_id = id

func _craft(entry: Dictionary) -> Dictionary: return entry.item.item.craft

func recipe(items: Array) -> Array:
	_recipes = _craft(items[SECOND]).o
	var first = _craft(items.front()).o
	return first



func make_slot(slot: int) -> Dictionary:
	return search.form(slot, search.logic.slot(slot))

func _can_product(cells: Array, slots: Array) -> bool:
	for i in len(slots):
		if not search.item_slot(slots[i]):
			return false
		cells.append(search.item)
	return true

func craft(slots: Array) -> void:
	var cells: Array = []
	if _can_product(cells, slots):
		search.put_crafted_item(cells, preview.craft_id)
	else:
		search.default_message()


var item: Dictionary = Def.DICT
var _cost: int = Def.INT

func get_id(slot: int) -> int: return logic.slot(slot).id

func default_message() -> void: logic.items.ui.helping()

func form(no: int, cell: Dictionary) -> Dictionary:
	return { "slot": no, "id": cell.id, "cell": cell, "item": logic.item(cell.id) }

func _find_item(algorithm: String, id: int, feedback: Callable) -> bool:
	var slot: int = logic.items.get(algorithm).call(id)
	if logic.items.ui.have(slot):
		feedback.call(slot)
		return true
	return false

func same_item() -> bool:
	return _find_item("find_same_item", item.id, func(s): item.cell = logic.slot(s))

func same_slot() -> bool:
	return logic.items.ui.same_item_search(item.id, logic.slot(item.slot))

func item_slot(_item: Dictionary) -> bool:
	item = _item
	return same_slot() or find_item(SAME_ITEM)

func _minimum(i: Dictionary) -> void:
	if i.cell.x < _cost: _cost = i.cell.x

func _put_items(i: Dictionary) -> void:
	logic.items.put_items(i.slot, i.id, i.cell.x - _cost)

func _iterate(items: Array, feedback: Callable) -> void:
	for i in items: feedback.call(i)

func min_cell(items: Array) -> int:
	_cost = logic.items.ui.MAX
	for f in [_minimum, _put_items]: _iterate(items, f)
	return _cost

func put_product(cells: Array, id: int, slot: int) -> void:
	logic.items.put_items(slot, id, min_cell(cells))

func put_crafted_item(cells: Array, id: int) -> void:
	_find_item("find_item_or_slot", id, func(slot):
		put_product(cells, id, slot))


# CRAFT

var bank: Dictionary
var space: Dictionary = Def.DICT
var select: Dictionary:
	get: return bank[space.id][space.x - 1]

var available: bool:
	get: return space != Def.DICT 

func _slot() -> Dictionary: return { "equip": [], "cross": Def.DICT }
func _equip(slot: int) -> Dictionary:
	var id: int = logic.slot(slot).id
	return { "item": logic.item(id), "id": id }

func select_weapon(slot: int) -> void:
	space = logic.slot(slot).duplicate()

func _tail_to_bank(id: int, slot: Dictionary) -> int:
	if bank.has(id):
		bank[id].append(slot)
	else:
		bank[id] = [slot]
	return len(bank[id])

func add_weapon(slot: int) -> void:
	var meta: Dictionary = logic.slot(slot)
	if logic.items.items.is_equipable(meta.id):
		meta.x = _tail_to_bank(meta.id, _slot())

func add_slot(slot: int) -> void:
	select.equip.append(_equip(slot))

func add_cross(slot: int) -> void:
	select.cross = logic.slot(slot).duplicate()


func _ready() -> void:
	craft.selection.drag = self
	craft.selection.select = select
	craft.select = select
	craft.trade = get_parent()

func trade(cell: CellDrag) -> void: # ui.remove_item
	ui.reset_texture(cell.image)
	select.trades(cell.slot)

func trades(prev: CellDrag, next: CellDrag) -> void:
	if select.craft_selected(prev.slot):
		craft.selection.craft_more_items(next.slot)
	else:
		select.set_selection(prev.drag.inventory, prev.slot)
		trade(next)

func moving_items(view: Control) -> void:
	if not select.is_selected():
		select.from_ui(view)
	else:
		select.release_item(view)

func select_item(option: Button) -> void:
	if craft.items(option): return
	if equip.items(): return
	moving_items(option.margin.view)

func select_space() -> void:
	if select.is_space():
		craft.trade.craft.reset()
		select.reset_selection()
	else:
		select.from_space(self)




func _cursor() -> Dictionary: return { "bag": HUD.NODE, "slot": Def.INT }

func set_selection(bag: Node, slot: int) -> void: main.bag = bag ; main.slot = slot

func craft_selected(slot: int) -> bool: return slot == CRAFT

func is_space() -> bool: return main.slot == SPACE

func is_craft() -> bool: return craft_selected(main.slot)

func is_selected() -> bool: return main.slot != Def.INT

func reset_selection() -> void: set_selection(HUD.NODE, Def.INT)

func from_ui(ui: Control) -> void: from_space(ui.drag, ui.slot)

func from_space(drag: Node, slot: int = SPACE) -> void:
	set_selection(drag.inventory, slot)

func trades_bag(bag: Node, slot: int) -> void:
	bag.logic.items.trade.bags(items, main.slot, slot)

func trades(slot: int) -> void: trades_bag(main.bag, slot)

func release_item(view: Control) -> void:
	trades(view.slot)
	reset_selection()






func select_to_craft(ui: Button) -> bool:
	if not select.is_selected() or select.is_space():
		select.from_ui(ui.margin.view)
	else:
		trade.craft.one_item(select.main)
	return true

func is_product(ui: Button) -> bool:
	return ui.margin.view.slot == select.CRAFT

func items(ui: Button) -> bool:
	if select.was_selected():
		return trade.craft.one_slot(select.main)
	if is_product(ui): return select_to_craft(ui)
	return false


func _release_item(view: CellDrag) -> void:
	drag.trade(view)#select.main.bag.logic, select.main.slot)
	select.reset_selection()

func trade_items(view: Control) -> void: drag.craft.trade.trades(view)

func craft_all_items() -> void: pass

func craft_more_items(slot: int) -> void:
	craft.one_slot(slot)
	select.reset_selection()

func hold_selection(view: Control) -> void:
	select.set_selection(view.drag.inventory, view.slot)

func craft_one_item(_v) -> void: craft.one_item(select.main)

func equiping_items(view: Control) -> bool:
	if select.is_space():
		trade_items(view)
		return true
	if select.is_craft():
		craft_more_items(view.slot)
		return true
	return false

func crafting_items(view: Control) -> bool:
	if select.is_space():
		trade_items(view)
		return true
	if select.is_craft():
		craft_more_items(view.slot)
		return true
	if select.craft_selected(view.slot):
		select_to_craft(view)
		return true
	return false

func _hold_if_selected(on_release: String, view: Control) -> void:
	if not select.is_selected():
		hold_selection(view)
	else:
		get(on_release).call(view)

func select_to_craft(view: Control) -> void:
	_hold_if_selected("craft_one_item", view)

func moving_items(view: Control) -> void:
	_hold_if_selected("_release_item", view)

func select_item(view: Control) -> void:
	if crafting_items(view): return
	if equiping_items(view): return
	moving_items(view)


func _get_icon(id: int) -> StringName:
	match id:
		JAR: return &"res://icon/item/a_jar.svg"
		ANTIDOTE: return &"res://icon/item/a_antidote.svg"
		GOLD_KEY: return &"res://icon/item/a_gold.svg"
		SECRET_KEY: return &"res://icon/item/a_secret.svg"
		OPUNTIA: return &"res://icon/item/a_opuntia.svg"
		STICKS: return &"res://icon/item/a_saksaul.svg"
		TAMARISK: return &"res://icon/item/a_tamarisk.svg"
		TUMBLEWEED: return &"res://icon/item/a_tumbleweed.svg"
		YUKKA: return &"res://icon/item/a_yukka.svg"
		WATER: return &"res://icon/item/e_water.svg"
		ETHER: return &"res://icon/item/e_ether.svg"
		TEA: return &"res://icon/item/e_tea.svg"
		CORETOOTH: return &"res://icon/item/m_coretooth.svg"
		SHIELD: return &"res://icon/item/m_shield.svg"
		I_ARMOR:  return &"res://icon/item/m_i_armor.svg"
		L_ARMOR:  return &"res://icon/item/m_l_armor.svg"
		I_PANTS:  return &"res://icon/item/m_i_pants.svg"
		L_PANTS:  return &"res://icon/item/m_l_pants.svg"
		I_BOOTS:  return &"res://icon/item/m_i_boots.svg"
		L_BOOTS:  return &"res://icon/item/m_l_boots.svg"
		BOOMERANG:  return &"res://icon/item/n_boomerang.svg"
		R_SCHO45:  return &"res://icon/item/n_schofield45.svg"
		R_ENLIGHT:  return &"res://icon/item/n_enlighten.svg"
		KNUCKLES:  return &"res://icon/item/n_knuckles.svg"
		SHOE:  return &"res://icon/item/n_shoe.svg"
		SHOTGUN:  return &"res://icon/item/n_shotgun.svg"
		T_RAPIER:  return &"res://icon/item/n_t_rapier.svg"
		W_RAPIER:  return &"res://icon/item/n_w_rapier.svg"
		SAW_STRING:  return &"res://icon/item/n_saw_string.svg"
	return &""

func get_slot(slot: int) -> Dictionary: return logic.slot(slot)

func move(e: InputEvent) -> void:
	if (e is InputEventMouseButton and (e.button_index == MOUSE_BUTTON_LEFT) and e.is_released()):
		reset_texture(_image)

func put_item(item: Dictionary, image: TextureRect) -> void:
	var path: String = PREVIEW.ICON
	if item.has("item"):
		path += item.item.icon
	else:
		path += logic.item(item.id).item.icon
	var file: Image = Image.load_from_file(path)
	image.texture = ImageTexture.create_from_image(file)

func reset_holder() -> void: holder = null

func remove_item(image: TextureRect) -> void:
	image.texture = null

func reset_texture(image: TextureRect) -> void:
	if holder != null:
		image.texture = holder
		reset_holder()

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
	remove_item(cell.image)
	return cell

func _input(event: InputEvent) -> void: move(event)


func equipped() -> Dictionary:
	return logic.item(equip.space.id)

func _ready() -> void:
	drag.craft.selection.craft = craft
	ui.trade = self
	craft.slots = TradeSlots.new()

func set_logic(l: Node) -> void:
	logic = l
	craft.placement.search.logic = logic
	equip.logic = logic

func description(item: Variant) -> void: #describe.emit(item, self)
	craft.slots.reload()
	ui.describe(item)

func trades(cell: CellDrag) -> void:
	drag.ui.reset_texture(cell.image)
	add_slot(cell.slot)

func check_weapon(id: int, slot: int) -> bool:
	var i: GameItems = logic.items.items
	if i.is_equipable(id):
		equip.select_weapon(slot)
	elif equip.available and i.equip.in_items(id):
		equip.add_slot(slot)
		ui.equipment()
		return false
	return true

func add_slot(slot: int) -> void:
	var id: int = logic.slot(slot).id
	var type: int = logic.items.items.craft(id)
	match type:
		GameItems.CRAFT: craft.add_slot(slot)
		GameItems.EQUIP, GameItems.ITEM:
			if check_weapon(id, slot):
				description(logic.item(id))

func confirm_item() -> void:
	match craft.slots.load:
		TradeSlots.CRAFT: craft.product()



var title: Array[HBoxContainer] = []
var size: int
var slots: Array:
	get: return trade.craft.slots.slots

func _drag(cell: CellDrag) -> void:
	cell.drag = trade.drag
	cell.slot = size
	size += 1

func _add_ui(res: Array, ui: Variant, iterator: Callable) -> void:
	res.append(ui)
	iterator.call(func(i): _drag(i.margin.view))
