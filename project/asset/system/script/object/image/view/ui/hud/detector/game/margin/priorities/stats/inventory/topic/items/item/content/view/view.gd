extends Control

class_name CellDrag

@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

var slot: int = 0
var inventory: Node

func _get_drag_data(_pos: Vector2) -> Variant:
	set_drag_preview(image.get_cursor_preview())
	remove_item()
	return self

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool:
	return cell is CellDrag # Dictionary

func _drop_data(_pos: Vector2, cell: Variant) -> void:
	cell.image.holder = null
	inventory.logic.trade_inventory(cell.slot, slot)

func remove_item() -> void: image.remove_item()

func put_item(item: Dictionary) -> void:
	image.put_item(inventory.items.items[item.id].icon)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		image.reset_texture()
