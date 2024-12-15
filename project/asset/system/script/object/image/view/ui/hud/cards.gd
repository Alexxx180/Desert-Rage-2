extends CanvasLayer

@export var progress: bool = false

func _ready() -> void:
	#var hints: VBoxContainer = detector.get_node("game/margin/hints")
	
	if progress:
		#hints.motion.show_full_help()
		#hints.help.visible = true
		$hud/detector/pause/margin/stretch/menu/help.hide()
