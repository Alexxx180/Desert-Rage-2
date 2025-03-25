extends VBoxContainer

@onready var resume: Button = $resume
@onready var help: Button = $help
@onready var screen: Button = $screen
@onready var exit: Button = $exit

var focused: bool = true

func _input(_event: InputEvent) -> void:
	if focused: return

	var pressed: bool = focused
	var acts: Array[String] = ["down", "up", "left", "right", "focus_next", "focus_prev"]
	var options: Array[Button] = [exit, resume, resume, resume, exit, resume] # right help
	var i: int = acts.size()

	while i > 0 and not (pressed or focused):
		i -= 1
		focused = options[i].has_focus()
		pressed = Input.is_action_just_pressed("ui_" + acts[i])

	if not focused and pressed:
		options[i].grab_focus()
		focused = true
