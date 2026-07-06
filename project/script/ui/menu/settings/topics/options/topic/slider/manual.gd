extends Node

@onready var loudness: HSlider = get_parent()
@onready var focus: Node = $focus
#@onready var timer: Timer = $timer
#@onready var timing: ActionTimer = $action

enum { TICK = 1, CLOCK = 10, MIN = 0, MAX = 100 }

var _value: String = ""
var _freeze: float = 0

func _reset() -> void: _value = ""

func _ready() -> void:
	focus.setup_items(self)
	focus.timing.MAX = 1000
	focus.timing.preview.connect(set_preview)
	focus.gamepad.special = true
	focus.timing.finish.wait_time = 1
	#focus.timing.action.period = 0.15

func first() -> void: loudness.set_to(MIN)
func last() -> void: loudness.set_to(MAX)

func set_space(point: float, system: float) -> void:
	var proportion: float = (point / system) * MAX
	loudness.safe_set(proportion)

func set_preview(value: int) -> void:
	loudness.safe_set(value)

func set_slider_value() -> void:
	var tick: float = Input.get_axis("ui_left", "ui_right")
	var clock: float = Input.get_axis("ui_down", "ui_up")
	if clock != 0 or tick != 0:
		loudness.append(clock * CLOCK + tick * TICK)
		_freeze = 0.05

func _physics_process(delta: float) -> void:
	if _freeze > 0:
		_freeze -= delta
	else:
		set_slider_value()
