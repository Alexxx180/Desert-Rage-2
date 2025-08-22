extends VBoxContainer

@onready var bar: ProgressBar = $bar
@onready var number: Label = $number

func set_value(next: int) -> void:
	show()
	if next == 1:
		number.text = ""
		bar.value = 0
	else:
		number.text = str(next)
		bar.value = next
