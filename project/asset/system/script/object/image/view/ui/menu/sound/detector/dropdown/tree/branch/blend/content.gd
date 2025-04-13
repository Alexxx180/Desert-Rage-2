extends Node

@onready var themes: VBoxContainer = $themes
@onready var slider: VSlider = $mix

var caption: String:
	set(value):
		themes.head.caption = value

func set_metadata(mix: int) -> void:
	slider.value = mix
	themes.head.set_metadata(mix)
