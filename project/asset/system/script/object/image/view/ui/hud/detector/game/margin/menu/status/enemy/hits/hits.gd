extends VBoxContainer

@onready var hundred: Control = $count/hundred
@onready var ten: Control = $count/ten
@onready var one: Control = $count/one

func set_count(hits: int) -> void:
	show()
	hundred.set_digit(hits / 100 % 10)
	ten.set_digit(hits / 10 % 10)
	one.set_digit(hits % 10)
