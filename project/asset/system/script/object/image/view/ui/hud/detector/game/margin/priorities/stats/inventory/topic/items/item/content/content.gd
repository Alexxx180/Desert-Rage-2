extends MarginContainer

@onready var view: Control = $view
@onready var selection: Control = $selection

func remove_item() -> void: # var inventory: Node # TODOT inv
	view.drag.ui.remove_item(view.image)
	selection.remove_item()

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	for item in [next, prev]: put_item(item)

func put_item(item: Dictionary) -> void:
	view.drag.ui.put_item(item, view.image)
	selection.put_item(item)
