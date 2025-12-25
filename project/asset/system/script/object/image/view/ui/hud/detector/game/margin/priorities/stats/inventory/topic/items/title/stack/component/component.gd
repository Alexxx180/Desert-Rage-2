extends HBoxContainer

@onready var two: HBoxContainer = $two
@onready var four: HBoxContainer = $four
@onready var items: Array[Control] = [two.a, two.b, four.a, four.b]

enum { FREE = 0, CRAFT = 1, WEAPON = 2 }

var load: int = FREE

func update_slots(slots: Array, type: int) -> void:
	load = type
	for i in [two, four]: i.hides()
	for i in range(0, slots.size()):
		items[i].show()
		items[i].put_item(slots[i])
