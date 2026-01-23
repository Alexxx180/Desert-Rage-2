extends Node

var options: Array#[Control]
var focused: bool = true
var mouse_check: bool = false

func _input(event: InputEvent) -> void:
	if focused: return

	if mouse_check and event is InputEventMouseButton:
		focused = false
		return

	var pressed: bool = focused
	var acts: Array[String] = ["down", "up", "left", "right", "focus_next", "focus_prev"]
	var i: int = acts.size()

	while i > 0 and not (pressed or focused):
		i -= 1
		if options[i] == null: continue # TODO FIXME NULL options focus on arrows
		focused = options[i].has_focus()
		pressed = Input.is_action_just_pressed("ui_" + acts[i])

	if not focused and pressed:
		options[i].grab_focus()
		focused = true
