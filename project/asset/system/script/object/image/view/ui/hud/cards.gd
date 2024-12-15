extends CanvasLayer

@export var no_progress: bool = false

func _ready() -> void:
	var detector: MarginContainer = $hud/detector
	var hints: VBoxContainer = detector.get_node("game/hints")
	var help: Button = detector.get_node("pause/menu/help")
	
	if no_progress:
		hints.motion.show_full_help()
		#hints.help.visible = true
		help.show()
