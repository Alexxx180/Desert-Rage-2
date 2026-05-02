extends Timer

class_name ControlTimeHooder

const TIME: float = 0.5

@export var fix_on_press: bool = false
@export var target_path: String = ".."

var state: Control
var target: Control
var fixed: bool = false

func _ready() -> void:
	state = get_parent()
	target = get_node(target_path)
	if fix_on_press: state.pressed.connect(set_fixed)
	for s in [state.focus_entered, state.mouse_entered]: s.connect(in_focus)
	for s in [state.focus_exited, state.mouse_exited]: s.connect(out_focus)
	_start_hide()

func _change_state(color: Color) -> void:
	create_tween().tween_property(target, "modulate", color, TIME)

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

func hide_pause() -> void: _change_state(Color.TRANSPARENT)
