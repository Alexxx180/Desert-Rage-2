extends GridContainer

@onready var two: VBoxContainer = $two
@onready var four: VBoxContainer = $four
@onready var items: Array[Control] = [two.a, two.b, four.a, four.b]

func hides() -> void: for i in [two, four]: i.hides()

func _iterate(rang: Variant, feedback: Callable) -> void:
	for i in rang:
		feedback.call(i)
		items[i].show()

func equipment(slots: Array, item: IArmor) -> void: #production(slots) # item.equip.size()
	#items[0].put_item(slots[0].item.item.icon)
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func production(slots: Array) -> void:
	hides()
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))

func describe(item: Dictionary) -> void:
	hides()
	if item.logic is IArmor:
		_iterate(len(item.logic.equip), func(_i): pass)
