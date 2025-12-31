extends HBoxContainer

@onready var component: HBoxContainer = $component
@onready var item: MarginContainer = $item

func set_item(i: Dictionary) -> void: item.set_item(i)

func update_slots(slots: Array, type: int) -> void:
	component.update_slots(slots, type)
	var i = slots.back()
	if i == null:
		item.helping()
	else:
		item.set_item(i.item)

func helping() -> void:
	component.hides()
	item.helping()
