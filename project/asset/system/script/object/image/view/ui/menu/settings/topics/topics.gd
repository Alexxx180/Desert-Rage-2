extends VBoxContainer

@onready var options: VBoxContainer = $content/margin/options
@onready var caption: Control = $tabs/caption

func _ready() -> void:
	caption.set_transition(options)
