extends CanvasLayer

@export var progress: HelpPreview
@onready var hud: Control = $hud
#@export var progress: bool = false

func _ready() -> void:
	$hud/detector/game/margin/hints.preview = progress
	#pass
	#var hints: VBoxContainer = detector.get_node("game/margin/hints")
	
	#if progress:
		#hints.motion.show_full_help()
		#hints.help.visible = true
		#$hud/detector/pause/margin/stretch/menu/help.hide()
