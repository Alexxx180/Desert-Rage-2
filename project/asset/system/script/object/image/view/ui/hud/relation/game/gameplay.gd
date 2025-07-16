extends Node

func controls(hud: CanvasLayer, options: HFlowContainer) -> void:
	var play: Node = hud.processor.game.play
	play.options = options
	options.menu.pressed.connect(play.pressed)
