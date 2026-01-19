extends HBoxContainer

@onready var status: HBoxContainer = $status
@onready var timing: VBoxContainer = $timing

func set_values(item: UseItem) -> void:
	timing.set_power(item)
	status.set_refill(item)

func set_status(item: Variant) -> void:
	status.set_effect(item)
	#if 
	#timing.set_time(item.time)

func set_effect(item: Variant) -> void:
	show()
	if item is UseItem:
		set_values(item)
	else:
		set_status(item)
