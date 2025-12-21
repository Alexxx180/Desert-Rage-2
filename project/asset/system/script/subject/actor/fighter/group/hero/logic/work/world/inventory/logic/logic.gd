extends Node

@onready var items: Node = $items
@onready var effect: Node = $effect

func put_to_inventory(id: int) -> bool:
	var slot: int = items.decide_item_or_equipment(id)
	var found: bool = items.ui.have(slot)
	if found: items.put_item(slot, id)
	return found
