extends Resource

class_name ActionButtonComplex

## Provide an interface to Manage Game Controls
## Used to be AND in-game condition

@export var action: String
@export var complex: Array[ActionButtonGroup] = []
@export var passthru: bool

var count: int:
	get: return complex.size()

var max_button_count: int: get = _get_max_button_count

func _get_max_button_count() -> int:
	var i: int = 0
	for group in complex:
		var j: int = group.count
		if j > i:
			i = j
	return i
