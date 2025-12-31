extends Node

var base: Dictionary

var logic: Node
var slots: TradeSlots

func add_slot(slot: int) -> void:
	var item: EquipItem
	var i: Dictionary = logic.items.get_item(slot)
	#i.
	# slots.equip()
	#slots.append([slot, item])
	#if slots.busy(item):
	#	slots.reset()
