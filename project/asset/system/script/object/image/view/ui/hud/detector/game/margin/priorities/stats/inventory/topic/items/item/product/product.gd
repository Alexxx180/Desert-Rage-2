extends Button

@onready var margin: MarginContainer = $margin

func _ready() -> void: pressed.connect(select_item)

func put_item(item: Dictionary) -> void:
	show()
	margin.view.drag.ui.put_item(item, margin.view.image)

func select_item() -> void:
	margin.view.drag.select_item(self)
