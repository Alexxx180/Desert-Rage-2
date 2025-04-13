extends Control

@onready var open: Control = $open
@onready var close: Control = $close

func set_active(expanded: bool) -> void:
	open.visible = !expanded
	close.visible = expanded
