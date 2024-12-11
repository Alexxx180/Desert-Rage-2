extends HBoxContainer

@onready var closed: Label = $closed
@onready var opened: Label = $opened

func set_state(open: bool) -> void:
	closed.visible = !open
	opened.visible = open
