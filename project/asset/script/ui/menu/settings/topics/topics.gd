extends HBoxContainer

@onready var options: VBoxContainer = $content/options
@onready var tabs: VFlowContainer = $tabs/options

func _ready() -> void:
	tabs.caption.set_transition(options)
