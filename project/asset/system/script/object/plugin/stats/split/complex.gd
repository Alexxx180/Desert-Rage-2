extends RefCounted

class_name ActionButtonComplex

## Provide an interface to Manage Game Controls
## Used to be AND in-game condition

var complex: Array[ActionButtonGroup] = [
	ActionButtonGroup.new()
]

var count: int:
	get: return complex.size()

var max_button_count: int: get = _get_max_button_count

func _get_max_button_count() -> int:
	var i: int = 0
	for i in range():
		pass
