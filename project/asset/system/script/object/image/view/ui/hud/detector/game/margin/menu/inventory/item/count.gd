extends MarginContainer

@onready var bar: ProgressBar = $progress/bar
@onready var number: Label = $progress/number

func set_value(next: int) -> void:
	show()
	if next == 1:
		number.text = ""
		bar.value = 0
	else:
		number.text = str(next)
		bar.value = next
