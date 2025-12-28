extends Node

var logic: Node
var preview: Node

func get_id(slot: int) -> int: return logic.slot(slot).id
func default_message() -> void: logic.items.ui.helping()

func make_slot(slot: int) -> Dictionary:
	return { "slot": slot, "item": logic.item(slot), "id": get_id(slot) }

func slot_search(j: Array) -> Dictionary:
	var id: int = j[TradeSlots.ID]
	var slot: Dictionary = logic.slot(j[TradeSlots.SLOT])
	var ui: Node = logic.items.ui
	
	if ui.same_item_search(slot, id): return slot
	
	var i: int = logic.items.find_same_item(id)
	if not ui.have(i): return Defaults.DICT
	
	return logic.item(i)

func production(items: Array, slots: Array) -> bool:
	var found: bool = true
	var i: int = len(slots)
	while (i > 0 and found): #for i in slots.slots:
		i -= 1
		var item: Dictionary = slot_search(slots[i])
		found = item == Defaults.DICT
		if found: items.append(item)
	return found

func craft(items: Array) -> void:
	var slot: int = logic.items.find_item_or_slot(preview.craft_id)
	if not logic.items.ui.have(slot): return
	
	var count: int = logic.items.ui.MAX
	
	for i in items: if i.x < count: count = i.x
	for i in items: i.x = count
	
	logic.items.put_items(slot, preview.craft_id, count)

func try_craft(slots: Array) -> void:
	var items: Array = []
	if production(items, slots):
		craft(items)
	else:
		default_message()
