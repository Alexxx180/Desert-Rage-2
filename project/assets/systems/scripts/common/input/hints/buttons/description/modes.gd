extends HBoxContainer

@onready var window: Label = $window
@onready var fullscreen: Label = $fullscreen

func set_window_mode(full: bool) -> void:
	window.visible = !full
	fullscreen.visible = full
