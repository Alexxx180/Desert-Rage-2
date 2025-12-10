extends VBoxContainer

@onready var bar: ProgressBar = $bar
@onready var number: Label = $number

const BOUNDARY: int = 1

func set_values(label: String, next: int) -> void:
	number.text = label
	bar.value = next

func remove_item() -> void: set_values("", 0)

func set_value(next: int) -> void:
	show()
	if next == BOUNDARY:
		remove_item()
	else:
		set_values(str(next), next)
