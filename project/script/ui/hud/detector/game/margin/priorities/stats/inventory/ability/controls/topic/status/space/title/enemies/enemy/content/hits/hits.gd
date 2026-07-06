extends HBoxContainer

enum { DIGIT = 10, MAX = 999 }

@onready var digits: Array[Control] = [$hundred, $ten, $one]

func hide_all() -> void:
	hide()
	for digit in digits: digit.hide_digit()

func set_count(hits: int) -> void:
	if hits > MAX: return
	show() # var x: Array[int] = [100, 10, 1]
	for i in range(0, 3):
		digits[i].set_digit(hits / (DIGIT ** (2 - i)) % DIGIT)
