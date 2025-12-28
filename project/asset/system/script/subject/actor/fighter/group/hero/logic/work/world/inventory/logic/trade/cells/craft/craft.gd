extends Node

signal new_slot()

const MAX: int = 2

var slots: TradeSlots

@onready var preview: Node = $preview
@onready var placement: Node = $placement

func set_logic(logic: Node) -> void:
	placement.preview = preview

func add_slot(slot: int) -> void:
	slots.craft()
	slots.append(placement.make_slot(slot)) # [slot, item, placement.get_id(slot)])
	if slots.busy(MAX): slots.reset()

func product() -> void: placement.try_craft(slots.slots)
