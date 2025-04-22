extends VBoxContainer

@onready var options: VBoxContainer = $content/margin/options
@onready var tabs: HBoxContainer = $tabs

func _ready() -> void:
	tabs.caption.set_transition(options)
