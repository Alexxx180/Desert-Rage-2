extends HBoxContainer

@onready var two: VBoxContainer = $two
@onready var four: VBoxContainer = $four
@onready var items: Array[Control] = [two.a, two.b, four.a, four.b]

func hides() -> void: for i in [two, four]: i.hides()

func _iterate(rang: Variant, feedback: Callable) -> void:
	for i in rang:
		feedback.call(i)
		items[i].show()

func equipment(slots: Array, item: ArmorItem) -> void:
	production(slots)
	_iterate(range(len(slots), item.equip.size()), Defaults.FUNC)

func production(slots: Array) -> void:
	hides()
	_iterate(len(slots), func(i):
		items[i].put_item(slots[i].item.item.icon))
