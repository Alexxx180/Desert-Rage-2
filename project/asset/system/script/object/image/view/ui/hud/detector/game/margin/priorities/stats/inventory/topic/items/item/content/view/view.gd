extends Control

class_name CellDrag

@onready var image: TextureRect = $image
@onready var both: TextureRect = $both

var slot: int ; var drag: Node

func _get_drag_data(_p) -> CellDrag: return drag.set_preview(self)
func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: drag.trade(cell)

func _input(event: InputEvent) -> void:
	if drag.ui.move(event): drag.reset_texture(image)
