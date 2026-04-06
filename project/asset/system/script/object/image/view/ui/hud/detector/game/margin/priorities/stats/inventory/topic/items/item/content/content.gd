class_name CellDrag extends TextureRect

@onready var count: Label = $count
@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

const BOUNDARY: int = 1

var slot: int
var drag: Node

func _get_drag_data(_p) -> CellDrag: return drag.ui.set_preview(self)
func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: drag.trades(cell, self)

func remove_item() -> void: # var inventory: Node # TODOT inv
	drag.ui.remove_item(image)
	count.text = ""

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	for item in [next, prev]: put_item(item)

func put_item(item: Dictionary) -> void:
	drag.ui.put_item(item, image)
	set_value(item.x)

func set_value(next: int) -> void:
	count.text = "" if next == BOUNDARY else str(next)
