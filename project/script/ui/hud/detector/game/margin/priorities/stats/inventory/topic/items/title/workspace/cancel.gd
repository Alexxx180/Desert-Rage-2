extends Button

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

var trade: Node

func _can_drop_data(_p, cell: Variant) -> bool: return cell is CellDrag
func _drop_data(_p, cell: Variant) -> void: trade.trades(cell)

@onready var component: HBoxContainer = $component
@onready var title: HBoxContainer = $short/title
@onready var caption: Label = $short/margin/caption
@onready var effect: Label = $effect

func set_item(item: Dictionary) -> void:
	component.describe(item)
	title.set_item(item) #effects.set_effect(item.logic)
	effect.text = item.item.description
	caption.text = item.item.name

func helping() -> void:
	component.hides()
	title.effects.hide()
	caption.text = "Инвентарь, ЛКМ"
	title.effect.text = "Область для осмотра"

func equipment(slots: Array, equip: Dictionary) -> void:
	component.equipment(slots, equip.logic)
	# set_item(equip)

func production(slots: Array) -> void:
	component.production(slots)
	if slots.is_empty():
		helping()
	else:
		set_item(slots.back().item)
