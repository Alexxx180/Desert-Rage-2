extends Node

var storage: Array
@onready var items: Node = $items
@onready var effect: Node = $effect

func update_inventory_storage() -> void:
	var slot = len(storage)
	while slot > 0:
		slot -= 1
		items.update_item(slot, storage[slot])

func use_inventory(slot: int) -> void:
	storage[slot].x -= items.UNIT
	items.update_item(slot, storage[slot])

func put_to_inventory(no: int) -> bool:
	var slot: int
	if no in [0, 1]:
		slot = items.find_item_or_slot(storage, no)
	else:
		slot = items.find_empty_slot(storage)
	if slot != items.NONE:
		items.put_item(slot, storage[slot], no)
		return true
	return false

func use_the_jar(source: int, product: int, id: int) -> void:
	if items.have(product):
		items.use_item(source, storage[source])
		items.put_item(product, storage[product], id)

func fill_the_jar() -> void:
	var jar: int = items.find_same_item(storage, 0)
	if items.have(jar):
		var water: int = items.find_item_or_slot(storage, 1)
		use_the_jar(jar, water, 1)

func remember_inventory(hero: CharacterBody2D, no: int) -> void:
	var item: Item = effect.items.items[no]
	print("ITEM NO = ", no)
	var game: Control = hero.to.hud.display.detector.game
	game.controls.preview.chats.log.add_item(item.name)
