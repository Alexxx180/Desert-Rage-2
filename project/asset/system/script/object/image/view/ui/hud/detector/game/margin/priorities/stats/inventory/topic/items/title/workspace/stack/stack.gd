extends HBoxContainer

@onready var component: HBoxContainer = $component
@onready var item: MarginContainer = $item

func set_item(i: Dictionary) -> void: item.set_item(i)

func helping() -> void:
	component.hides()
	item.helping()
