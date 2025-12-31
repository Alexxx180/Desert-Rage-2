extends HBoxContainer

@onready var two: VBoxContainer = $two
@onready var four: VBoxContainer = $four
@onready var items: Array[Control] = [two.a, two.b, four.a, four.b]

func hides() -> void: for i in [two, four]: i.hides()

func update_slots(slots: Array, type: int) -> void:
	hides()
	for i in len(slots):
		items[i].put_item(slots[i].item.item.icon)
		items[i].show()
