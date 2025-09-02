extends Timer

class_name ControlTimeHider

const TIME: float = 0.5
var state: Control
var fixed: bool = false

func _ready() -> void:
	state = get_parent()
	_start_hide()

func _input(event: InputEvent) -> void:
	if fixed: return
	if event is InputEventMouseMotion or Input.get_axis("list_up", "list_down") != 0:
		_show_pause()
		start()

func _tween_property(caption: String, value: Variant) -> void:
	create_tween().tween_property(state, caption, value, TIME)

func _change_state(color: Color) -> void: _tween_property("modulate", color)

func _show_pause() -> void:
	if time_left == 0: _change_state(Color.WHITE)

func _start_hide() -> void:
	fixed = false
	start()
	
func _stop_hide() -> void:
	fixed = true
	_show_pause()
	stop()

func hide_pause() -> void:
	stop()
	_change_state(Color.TRANSPARENT)
