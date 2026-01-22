extends HBoxContainer

@onready var backward: Button = $backward
@onready var play: Button = $play
@onready var pause: Button = $play
@onready var forward: Button = $forward

var options: Array[Button]:
	get: return [backward, play, pause, forward]

func _toggle(state: bool) -> void:
	pause.visible = state
	play.visible = !state

func switch_skip() -> void:
	if !play.visible: _toggle(false)

func switch_play() -> void: _toggle(true)
