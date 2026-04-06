extends Button

@onready var view: TextureRect = $view

func _ready() -> void: pressed.connect(select_item)

func put_item(item: Dictionary) -> void:
	show()
	view.drag.ui.put_item(item, view.image)

func select_item() -> void:
	view.drag.select_item(self)
