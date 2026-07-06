extends HBoxContainer

@onready var component: HBoxContainer = $component
@onready var item: MarginContainer = $item

func set_item(i: Dictionary) -> void:
	item.set_item(i)
	component.describe(i)

func equipment(slots: Array, equip: Dictionary) -> void:
	component.equipment(slots, equip.logic)
	# set_item(equip)

func production(slots: Array) -> void:
	component.production(slots)
	if slots.is_empty():
		helping()
	else:
		set_item(slots.back().item)

func helping() -> void:
	component.hides()
	item.helping()
