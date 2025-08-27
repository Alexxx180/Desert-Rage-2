extends Node

var display: CanvasLayer #Control
var status: VBoxContainer:
	get: return display.detector.game.status

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)

func notify(text: String) -> void:
	status.hero.notify(text)
