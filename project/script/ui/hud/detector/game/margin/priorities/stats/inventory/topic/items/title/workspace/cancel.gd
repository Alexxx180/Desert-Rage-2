extends Button

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

var trade: Node

func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: trade.trades(cell)
