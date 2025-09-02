extends HBoxContainer

@onready var bar: ProgressBar = $space/bar
@onready var current: Label = $merge/flash/cork/margin/current

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)
