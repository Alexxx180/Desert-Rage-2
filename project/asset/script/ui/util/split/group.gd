extends Resource

class_name ActionButtonGroup

## Provide an interface to Manage Game Controls
## Used to be AND in-game condition

@export var group: Array[ActionButton] = []

var count: int:
	get: return group.size()
