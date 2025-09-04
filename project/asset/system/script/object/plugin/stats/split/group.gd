extends RefCounted

class_name ActionButtonGroup

## Provide an interface to Manage Game Controls
## Used to be AND in-game condition

var group: Array[ActionButton] = [
	ActionButton.new(), ActionButton.new()
]

var count: int:
	get: return group.size()
