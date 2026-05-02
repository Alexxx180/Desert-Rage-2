extends HBoxContainer

@onready var edit: HBoxContainer = $edit
@onready var play: HBoxContainer = $play

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)
