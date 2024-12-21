extends Timer

@onready var state: Button

var fixed: bool = false

func _ready() -> void:
	state = get_parent()
	_start_hide()

func _input(event: InputEvent) -> void:
	if fixed: return
	if event is InputEventMouseMotion or Input.get_axis("list_up", "list_down") != 0:
		_show_pause()
		start()

func _change_state(color: Color) -> void:
	var change: Tween = create_tween()
	change.tween_property(state, "modulate", color, 0.5)

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
