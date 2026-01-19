extends VBoxContainer

@onready var effect: Label = $effect
@onready var time: ProgressBar = $time

const PERIOD: float = 60

func a() -> String: return "A"
func r() -> String: return "R"
func ar() -> String: return a() + r()
func both() -> String: return "%d " + ar() + " %d"

func set_time(seconds: int) -> void:
	show()
	if seconds < PERIOD:
		effect.text = "%d s." % seconds
	else:
		effect.text = "%.1f m. " % (seconds / PERIOD)

func set_power(item: UseItem) -> void:
	show()
	effect.text = item.describe(self)
