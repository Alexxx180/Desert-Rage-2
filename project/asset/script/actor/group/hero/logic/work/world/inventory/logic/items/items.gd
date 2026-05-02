extends Node

@onready var ui: Node = $ui
@onready var trade: Node = $trade

var description: Label
var storage: Array
var items: GameItems

func _ready() -> void: trade.items = self

func update_inventory() -> void:
	for slot in range(len(storage) - 1, Defaults.INT, Defaults.INT):
		ui.update_item(slot, storage[slot])

func decide_item_or_equipment(id: int) -> int:
	if items.is_consumable(id):
		return find_item_or_slot(id)
	else:
		return find_empty_slot()

func find_item_or_slot(id: int) -> int:
	var slot: int = ui.NONE
	for i in range(0, len(storage)):
		var item: Dictionary = storage[i]
		if ui.empty_slot_search(slot, item): slot = i
		if ui.same_slot_search(id, item): return i
	return slot

func find_same_item(id: int) -> int:
	for i in range(0, len(storage)):
		if ui.same_item_search(id, storage[i]): return i
	return ui.NONE

func find_empty_slot() -> int:
	for i in range(0, len(storage)):
		if ui.is_empty(storage[i]): return i
	return ui.NONE

func replace_item(source: int, id: int) -> bool:
	var product: int = find_item_or_slot(id)
	if ui.have(product):
		use_item(source)
		put_item(product, id)
		return true
	return false

func get_item(slot: int) -> Dictionary: return storage[slot]
func get_count(slot: int) -> int: return storage[slot].x

func put_to_inventory(id: int) -> int:
	var slot: int = decide_item_or_equipment(id)
	if ui.have(slot): put_item(slot, id)
	return slot

func use_item(slot: int) -> void: # use_inventory
	storage[slot].x -= ui.UNIT
	ui.update_item(slot, storage[slot])

func add_item(slot: int) -> void:
	storage[slot].x += ui.UNIT
	ui.put_item(slot, storage[slot])

func put_item(slot: int, id: int) -> void:
	storage[slot].id = id
	add_item(slot)

func put_items(slot: int, id: int, count: int) -> void:
	storage[slot].id = id
	storage[slot].x = count
	ui.update_item(slot, storage[slot])
