extends VBoxContainer

@onready var hundred: Control = $count/hundred
@onready var ten: Control = $count/ten
@onready var one: Control = $count/one

func hide_all() -> void:
	hide()
	for digit in [hundred, ten, one]:
		digit.hide_digit()

func set_count(hits: int) -> void:
	show()
	var x: Array[int] = [100, 10, 1]
	var digits = [hundred, ten, one]
	for i in range(0, 3):
		digits[i].set_digit(hits / x[i] % 10)
