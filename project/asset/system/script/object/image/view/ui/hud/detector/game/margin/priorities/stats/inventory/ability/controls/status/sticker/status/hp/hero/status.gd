extends HBoxContainer

@onready var hp: ProgressBar = $hp

var _ailments: HBoxContainer = null
var ailments: HBoxContainer:
	get:
		if _ailments == null:
			_ailments = get_parent().ailments.instantiate()
			add_child(_ailments)
		return _ailments
