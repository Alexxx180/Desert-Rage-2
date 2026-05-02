extends HBoxContainer

@onready var copy: Button = $copy
@onready var restart: Button = $restart

func _toggle(state: bool) -> void:
	copy.visible = !state
	restart.visible = state

func switch_mode() -> void: _toggle(copy.visible)
