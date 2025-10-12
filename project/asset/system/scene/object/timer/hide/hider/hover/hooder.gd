extends Timer

class_name ControlTimeHooder

const TIME: float = 0.5

@export var fix_on_press: bool = false

var state: Control
var fixed: bool = false

func _ready() -> void:
	var next = get_parent()
	if fix_on_press: next.pressed.connect(set_fixed)
	state = next
	for s in [state.focus_entered, state.mouse_entered]: s.connect(in_focus)
	for s in [state.focus_exited, state.mouse_exited]: s.connect(out_focus)
	_start_hide()

func _tween_property(caption: String, value: Variant) -> void:
	create_tween().tween_property(state, caption, value, TIME)

func _change_state(color: Color) -> void: _tween_property("modulate", color)

func set_fixed() -> void:
	fixed = !fixed
	if fixed:
		_stop_hide()

func out_focus() -> void: if not fixed: _start_hide()
func in_focus() -> void: _stop_hide()

func _start_hide() -> void:
	start()

func _stop_hide() -> void:
	stop()
	_show_pause()

func _show_pause() -> void: _change_state(Color.WHITE)
# 	if time_left == 0: 

func hide_pause() -> void:
	_change_state(Color.TRANSPARENT)
