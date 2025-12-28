extends Button

@onready var title: HBoxContainer = get_node("../..")

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: title.trade(cell)
