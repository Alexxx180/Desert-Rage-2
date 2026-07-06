extends HFlowContainer

@onready var resume: Button = $resume
@onready var information: Button = $information
@onready var settings: Button = $settings
@onready var exit: Button = $exit
@onready var focus: Node = $focus

var focused: bool:
	get: return focus.focused
	set(value): focus.focused = value

func _ready() -> void:
	focus.options = [exit, resume, exit, resume, exit, resume]
