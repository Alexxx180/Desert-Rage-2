extends Button

class_name BinaryChoice

@onready var status: Label = $status

@export var _caption: Array = _default_caption()

var _choice: bool = false
var selection: String:
	get: return tr(_caption[int(_choice)])

func _default_caption() -> Array: return ["SOFF", "SON"]
func _view() -> Variant: return status

func sync_caption() -> void:
	_view().text = selection

func change_choice(state: bool = !_choice) -> void:
	_choice = state
	sync_caption()
