extends CanvasLayer

@onready var hints: VBoxContainer = $hud/margin/hints

@export var no_progress: bool = false

func _ready() -> void:
	if no_progress:
		hints.motion.show_full_help()
		hints.help.visible = true
