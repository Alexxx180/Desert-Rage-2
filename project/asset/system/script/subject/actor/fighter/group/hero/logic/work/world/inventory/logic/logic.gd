extends Node

@onready var items: Node = $items
@onready var effect: Node = $effect
@onready var sorting: Node = $sorting
@onready var trade: Node = $trade

func slot(no: int) -> Dictionary: return items.get_item(no)
func item(id: int) -> Dictionary: return items.items.get_item(id)

func _ready() -> void:
	trade.ui.ui = items.ui
	trade.drag.ui.logic = self
	trade.drag.select.items = items
	sorting.effect = effect
	sorting.items = items
	trade.set_logic(self)

func put_to_inventory(id: int) -> bool:
	return items.put_to_inventory(id)
