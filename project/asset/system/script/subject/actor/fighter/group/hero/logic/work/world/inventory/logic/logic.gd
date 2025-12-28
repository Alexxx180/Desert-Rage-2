extends Node

@onready var items: Node = $items
@onready var effect: Node = $effect
@onready var sorting: Node = $sorting
@onready var trade: Node = $trade

func slot(no: int) -> Dictionary: return items.get_item(no)
func item(no: int) -> Dictionary: return items.items.get_item(no)

func _ready() -> void:
	sorting.effect = effect
	sorting.items = items
	trade.set_logic(self)

func put_to_inventory(id: int) -> bool:
	return items.put_to_inventory(id)
