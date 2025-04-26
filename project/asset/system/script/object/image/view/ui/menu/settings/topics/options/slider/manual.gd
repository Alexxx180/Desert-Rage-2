extends Node

@onready var timer: Timer = $timer
@onready var loudness: HSlider = get_parent()
@onready var timing: ActionTimer = $action

enum { TICK = 1, CLOCK = 10, MIN = 0, MAX = 100 }

var _value: String = ""
var _numbers: bool = true

func _reset() -> void: _value = ""

func _continue_input() -> void:
	_numbers = true

func _ready() -> void:
	timing.period = 0.1
	timing.timeout.connect(_continue_input)

func manual_value() -> void:
	if Input.is_action_just_pressed("ui_home"):
		loudness.reset(0)
	elif Input.is_action_just_pressed("ui_end"):
		loudness.reset(100)
	else:
		var tick: float = Input.get_axis("ui_left", "ui_right")
		var clock: float = Input.get_axis("ui_down", "ui_up")
		loudness.append(tick * TICK + clock * CLOCK)

func keyed_value(event: InputEvent) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	if text.is_valid_int() and _value.length() < 3:
		_value += text
		loudness.reset(int(_value))
		_numbers = false
		timer.start()
		timing.start()
	else:
		manual_value()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and _numbers:
		keyed_value(event)
	else:
		manual_value()
