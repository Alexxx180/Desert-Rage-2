extends Node

@onready var themes: VBoxContainer = $themes
@onready var slider: VSlider = $mix

var caption: String:
	set(value):
		themes.head.caption = value

func set_metadata(mix: int) -> void:
	slider.value = mix
	themes.head.set_metadata(mix)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	slider.value_changed.connect(func(s): ost.mix = s)
	slider.value = clampi(ost.mix, 0, 100)
		#button_pressed = ost.mix
		#set_metadata(ost.theme.mix)
	#	_connected = true
