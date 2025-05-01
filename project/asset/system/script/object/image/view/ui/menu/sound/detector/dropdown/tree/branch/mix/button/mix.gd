extends Button

@onready var caption: VBoxContainer = $margin/caption

#var _connected: bool = false

func _toggled(toggled_on: bool) -> void:
	print("TOGGLE")
	set_metadata(toggled_on)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	toggled.connect(func(s): ost.mix = s)
	button_pressed = ost.mix
	#set_metadata(ost.theme.mix)
	#_connected = true

func set_metadata(status: bool) -> void:
	caption.status.text = "V" if status else "X"
