extends HBoxContainer

@onready var status: HBoxContainer = $status
@onready var timing: VBoxContainer = $timing

func set_values(item: UseItem) -> void:
	var type: int = item.describe()
	timing.set_power(item, type)
	status.set_refill(item, type)

func set_status(item: Variant) -> void:
	status.set_effect(item)
	timing.set_time(item.time)

func set_effect(item: Variant) -> void:
	show()
	if item is UseItem:
		set_values(item)
	else:
		set_status(item)
