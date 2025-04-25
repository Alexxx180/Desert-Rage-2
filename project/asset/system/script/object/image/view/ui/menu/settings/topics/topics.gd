extends VBoxContainer

@onready var options: VBoxContainer = $content/options
@onready var tabs: HFlowContainer = $tabs/options

func _ready() -> void:
	tabs.caption.set_transition(options)
