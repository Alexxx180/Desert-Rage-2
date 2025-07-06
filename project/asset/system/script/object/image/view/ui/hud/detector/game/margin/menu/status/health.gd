extends HBoxContainer

@onready var bar: ProgressBar = $bar
@onready var current: Label = $merge/margin/cork/margin/current

func set_value(actual: int) -> void:
	bar.value = actual
	current.text = str(actual)
