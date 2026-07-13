class_name FocusedSlider extends HSlider

signal hold_focus(status: bool)

@export var text: String = ""

@onready var submit: Button = $form/state/manual
@onready var caption: Label = $form/caption
@onready var manual: Node = $manual

var _manual: bool = false
var released: bool:
	get: return not _manual

func _ready() -> void:
	caption.text = text
	value_changed.connect(func(v: int):
		submit.text = str(v)#str(v, "%")
		if v == max_value:
			add_theme_icon_override("grabber", PreloadBus.grabber)
		else:
			add_theme_icon_override("grabber", null)
	)

func get_root() -> String: return "../../../../../../"

func get_neighbor() -> String:
	return "../" + name + "/margin/music/volume/state/info/manual"

func set_neighbor(left: String, right: String) -> void:
	var root: String = get_root()
	submit.focus_neighbor_left = root + left
	submit.focus_neighbor_right = root + right

func focus() -> void: manual.grab_focus()

func set_to(next: int) -> void:
	value = next
	value_changed.emit(value)

func safe_set(next: int) -> void:
	set_to(clampi(next, int(min_value), int(max_value)))

func append(tick: int) -> void:
	safe_set(int(value) + tick)

func focus_manual() -> void:
	set_manual(true)
	submit.release_focus()

func set_manual(next: bool) -> void:
	_manual = next
	Works.turn(manual, _manual)
	hold_focus.emit(!next)

func check_actions(_event: InputEvent) -> void:
	var actions: Array[String] = ["ui_cancel", "ui_accept", "list_right",
		"list_left", "list_up", "list_down", "ui_focus_next", "ui_focus_prev"]
	var i: int = actions.size() - 1
	var minimum: int = -1
	while i > minimum and not Input.is_action_just_pressed(actions[i]):
		i -= 1
	if i > minimum:
		set_manual(false)
		match actions[i]:
			"ui_accept": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_next": submit.find_next_valid_focus().grab_focus()
			#"ui_focus_prev": submit.find_prev_valid_focus().grab_focus()
			_: submit.grab_focus()

func _input(event: InputEvent) -> void:
	if not _manual: return
	if event is InputEventMouseButton:
		set_manual(false)
	else:
		check_actions(event)




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
