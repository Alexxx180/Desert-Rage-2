extends Node

var storage: Array
@onready var items: Node = $items
@onready var effect: Node = $effect

func update_inventory_storage() -> void:
	var slot = len(storage)
	while slot > 0:
		slot -= 1
		items.ui.update_item(slot, storage[slot])

func use_inventory(slot: int) -> void:
	storage[slot].x -= items.ui.UNIT
	items.ui.update_item(slot, storage[slot])

func put_to_inventory(no: int) -> bool:
	var slot: int = items.decide_item_or_equipment(storage, no)
	var found: bool = items.ui.have(slot)
	if found: items.put_item(slot, storage[slot], no)
	return found

func _copy(item: Dictionary, copied: Dictionary) -> Dictionary:
	item.id = copied.id
	item.x = copied.x
	return copied

func update_item(inventory: Node, slot: int) -> void:
	inventory.items.ui.update_item(slot, inventory.storage[slot])

func _trade(a: Dictionary, b: Dictionary) -> void:
	var temp: Dictionary = HeroInventory.slot()
	_copy(_copy(_copy(temp, b), a), temp)

func trade_inventory(slot_a: int, slot_b: int) -> void:
	_trade(storage[slot_a], storage[slot_b])
	for slot in [slot_a, slot_b]: update_item(self, slot)

func trade_bags(hero: Node, slot_a: int, slot_b: int) -> void:
	_trade(storage[slot_a], hero.storage[slot_b])
	for it in [[self, slot_a], [hero, slot_b]]: update_item(it[0], it[1])

func use_the_jar(source: int, product: int, id: int) -> void:
	if items.ui.have(product):
		items.use_item(source, storage[source])
		items.put_item(product, storage[product], id)

func fill_the_jar() -> void:
	var jar: int = items.find_same_item(storage, 0)
	if items.have(jar):
		var water: int = items.find_item_or_slot(storage, 1)
		use_the_jar(jar, water, 1)

func remember_inventory(hero: CharacterBody2D, no: int) -> void:
	var item: Item = effect.items.get_item(no).item
	print("REMEMBER ITEM NO = ", no)
	var game: Control = hero.to.hud.display.detector.game
	game.controls.preview.chats.log.add_item(item.name)
