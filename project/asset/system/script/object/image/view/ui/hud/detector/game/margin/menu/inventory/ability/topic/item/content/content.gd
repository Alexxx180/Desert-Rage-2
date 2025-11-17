extends MarginContainer

@onready var count: VBoxContainer = $selection/count
@onready var view: Control = $view
@onready var items: Control = get_node("../..")
@onready var icons: String = "res://asset/resource/media/image/inventory/"

func remove_item() -> void: # var inventory: Node # TODOT inv
	view.remove_item()

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	put_item(next)
	put_item(prev)

func put_item(slot: Dictionary) -> void:
	var item: Item = items.inventory.items.items[slot.id]
	view.put_item(icons + "items/bottle.svg") #  + item.icon
	count.set_value(slot.x)
