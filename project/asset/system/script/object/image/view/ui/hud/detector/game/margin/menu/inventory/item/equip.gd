extends InventoryItem

@onready var default: Control = $default

func remove_item() -> void:
	super.remove_item()
	default.show()

func put_item(selection: Dictionary, items: Dictionary) -> void:
	default.hide()
	super.put_item(selection, items)
