extends PanelContainer

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

func set_item(item: Dictionary) -> void: stack.set_item(item)

func update_slots(slots: TradeSlots, type: int) -> void:
	stack.component.update_slots(slots, type)
