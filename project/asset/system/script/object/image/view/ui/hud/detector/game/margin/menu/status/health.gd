extends Button

@onready var bar: ProgressBar = $points/space/bar
@onready var current: Label = $points/merge/cork/current

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)
