extends RefCounted

class_name TradeSlots

enum { FREE = 0, CRAFT = 1, EQUIP = 2 }

var load: int = FREE
var trade: Node
var slots: Array[int] = []

func item(slot: int) -> int:
	return slots[slot]

func busy(max: int) -> bool:
	return slots.size() >= max

func reset() -> void:
	slots.clear()

func reset_if() -> void:
	if load == slots.EQUIP:
		load = slots.CRAFT
