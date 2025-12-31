extends RefCounted

class_name TradeSlots

enum { SLOT = 0, ITEM = 1, ID = 2 }
enum { FREE = 0, CRAFT = 1, EQUIP = 2 }

var load: int = FREE # var trade: Node
var slots: Array[Dictionary] = []

func append(slot: Dictionary) -> void: slots.append(slot)
func item(slot: int) -> Dictionary: return slots[slot]
func busy(max: int) -> bool: return slots.size() > max
func reset() -> void: slots.clear()

func equip() -> void: set_load(CRAFT, EQUIP)
func craft() -> void: set_load(EQUIP, CRAFT)

func operate(type: String, max: int, slot: Dictionary) -> void:
	get(type).call()
	append(slot)
	if busy(max): reload()

func reload() -> void:
	reset()
	load = FREE

func set_load(current: int, next: int) -> void:
	if load in [current, FREE]: load = next
	if load == current: reset()
