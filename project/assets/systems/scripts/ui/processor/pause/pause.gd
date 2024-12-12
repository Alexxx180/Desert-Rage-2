extends Node

var 

var resume: Button
var pause: Button

func _toggle_pause(paused: bool) -> void:
	pause.button_pressed = paused
	resume.button_pressed = !paused


