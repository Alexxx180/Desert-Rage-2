extends Node

var display: CanvasLayer #Control

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)
