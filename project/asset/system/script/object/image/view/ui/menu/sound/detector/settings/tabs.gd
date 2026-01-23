extends VBoxContainer

# @onready var music: Button = $music
# @onready var sound: Button = $sound
@onready var play: Button = $play
@onready var edit: Button = $edit

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)
