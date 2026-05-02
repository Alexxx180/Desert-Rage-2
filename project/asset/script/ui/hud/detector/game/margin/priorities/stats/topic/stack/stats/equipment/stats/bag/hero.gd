extends TextureButton

signal switch_bags(bag: String)

@onready var back: PanelContainer = $back

var inventory: Node

func _ready() -> void: pressed.connect(switch)

func set_inventory(group: Node2D) -> void:
	inventory = group.get(name).to.inventory

func _can_drop_data(_pos: Vector2, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_pos: Vector2, cell: Variant) -> void: trade(cell)

func trade(cell: Control) -> void:
	var slot: int = inventory.logic.find_empty_slot()
	if slot != inventory.logic.items.ui.NONE:
		cell.image.holder = null
		cell.inventory.logic.trade_bags(inventory.logic, cell.slot, slot)

func switch() -> void: switch_bags.emit(name)
