extends Control

@onready var off: Control = $off
@onready var on: Control = $on

func toggle(is_on: bool) -> void:
	off.visible = !is_on
	on.visible = is_on
