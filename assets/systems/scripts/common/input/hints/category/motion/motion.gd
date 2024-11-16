extends VBoxContainer

signal on_hidden()

@onready var animation: AnimationPlayer = $animation
@onready var _acts = {
	"movement": $movement, "hill": $hill,
	"jumping": $jumping, "pushing": $pushing
}

var _progression: Array[String] = ["movement"]
var _showed: int = 0
var _in_progress: int = 0

func _show_hint(act: String) -> void:
	animation.play("hints_motion/" + act + "_appear")
	_showed += 1

func show_progress(act: String) -> void:
	if _in_progress:
		for item in _progression:
			_acts[item].hide()
	_in_progress = _progression.size() != 4
	_progression.append(act)
	_show_hint(act)
	
func hide_progress(act: String) -> void:
	if _acts[act].visible:
		_in_progress = true
		animation.play("hints_motion/" + act + "_disappear")

func show_hints() -> void:
	for act in _progression: _show_hint(act)

func hide_hints() -> void:
	for act in _progression: hide_progress(act)

func _on_hide() -> void:
	_in_progress = false
	_showed -= 1
	print("SHOWED? ", _showed)
	if _showed == 0: on_hidden.emit()
