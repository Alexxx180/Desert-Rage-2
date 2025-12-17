extends MarginContainer

@onready var items: HFlowContainer = $items

func _ready() -> void: items.set_items(name)
