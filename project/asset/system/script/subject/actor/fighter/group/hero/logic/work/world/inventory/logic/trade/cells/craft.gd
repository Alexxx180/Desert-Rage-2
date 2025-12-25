extends Node

const MAX: int = 2

var items: Node
var slots: TradeSlots

func busy() -> bool: return slots.size() >= MAX
func reset() -> void: slots.clear()

func add_slot(slot: int) -> void:
	if slots.load = slots.EQUIP:
		slots.load = slots.CRAFT
	trade.craft.reset()
	slots.append(slot)
	if slots.busy():
		slots.reset()
