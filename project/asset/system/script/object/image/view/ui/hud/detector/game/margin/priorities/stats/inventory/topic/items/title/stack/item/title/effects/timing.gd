extends VBoxContainer

@onready var effect: Label = $effect
@onready var time: ProgressBar = $time

enum { AURA = 0, RESOURCE = 1, AR = 2, BOTH = 3 }
const PERIOD: float = 60

func set_time(seconds: int) -> void:
	show()
	if seconds < PERIOD:
		effect.text = "%d s." % seconds
	else:
		effect.text = "%.1f m. " % (seconds / PERIOD)

func _get_power_text(item: UseItem, type: int) -> String:
	match type:
		UseItem.AURA: return "%d Ж" % item.power
		UseItem.RESOURCE: return "%d У" % item.supply
		UseItem.AR: return "%d ЖУ" % item.power
		UseItem.BOTH: return "%d ЖУ %d" % [item.power, item.supply]
	return ""

func set_power(item: UseItem, type: int) -> void:
	show()
	effect.text = _get_power_text(item, type)
