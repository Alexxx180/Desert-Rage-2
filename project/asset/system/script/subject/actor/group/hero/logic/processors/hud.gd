extends Node

var display: Control

func dialog(text: Array[String]) -> void:
	display.detector.game.chat.add_blocks(text)
