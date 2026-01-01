extends PanelContainer

@onready var cancel: Button = $cancel
@onready var stack: HBoxContainer = $stack

func describe(item: Dictionary) -> void: stack.set_item(item)

func update_slots(slots: TradeSlots, type: int) -> void:
	stack.update_slots(slots.slots, type)
