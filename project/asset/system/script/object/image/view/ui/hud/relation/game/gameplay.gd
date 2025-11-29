extends Node

@onready var skills: Node = $skills

func controls(hud: CanvasLayer, options: HFlowContainer) -> void:
	var play: Node = hud.processor.game.play
	play.options = options
	# options.menu.pressed.connect(play.pressed) # TODO FIXME ALT
	skills.controls(hud, options)
