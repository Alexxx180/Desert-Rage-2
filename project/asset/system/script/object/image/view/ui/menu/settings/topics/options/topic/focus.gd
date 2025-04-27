extends HFlowContainer

@onready var timing: ActionTimer = $action
@onready var timer: Timer = $timer

@export var space: int = 1

var items: Array[Control] = []

const MAX_KEY: int = 100
enum TRIGGER { LEFT = 4, RIGHT = 5 }
enum BUTTON { LEFT = 9, RIGHT = 10, Y = 2, X = 3 }

var _modifier: BitMap = BitMap.new()
var _value: int = 0

func _reset() -> void:
	items[min(_value, items.size() - 1)].grab_focus()
	_value = 0

func _continue_input() -> void:
	_modifier.set_bit(1, 0, true)

func _ready() -> void:
	_modifier.create(Vector2i(4, 1))
	_modifier.set_bit(1, 0, true)
	timing.period = 0.1
	timing.timeout.connect(_continue_input)
	for child in get_children():
		if child is HSlider:
			items.push_back(child.submit)
		elif child is Button:
			items.push_back(child)

func set_gamepad_base(base: int, check: int, active: int, pressed: bool) -> void:
	if _modifier.get_bit(check, 0):
		set_code_focus(base + 2)
	else:
		_modifier.set_bit(active, 0, pressed)

func set_gamepad_motion(event: InputEventJoypadMotion) -> void:
	print("AXIS: ", event.axis)
	match event.axis:
		TRIGGER.LEFT: set_gamepad_base(5, 3, 2, event.is_pressed())
		TRIGGER.RIGHT: set_gamepad_base(0, 2, 3, event.is_pressed())

func get_base() -> int:
	if _modifier.get_bit(2, 0): return 0
	return 5 if _modifier.get_bit(3, 0) else -1

func set_bamper_space_focus(base: int, modifier: int) -> void:
	if base != -1:
		set_code_focus(base + modifier)
	elif modifier == space:
		items[0].grab_focus()

func set_gamepad_button(event: InputEventJoypadButton) -> void:
	var base: int = get_base()
	if base == -1: return
	print("INDEX: ", event.button_index)
	match event.button_index:
		BUTTON.LEFT: set_bamper_space_focus(base, 0)
		BUTTON.RIGHT: set_bamper_space_focus(base, 1)
		BUTTON.X: set_code_focus(base + 3)
		BUTTON.Y: set_code_focus(base + 4)

func set_code_focus(no: int) -> void:
	if _modifier.get_bit(1, 0) and _value * 10 < MAX_KEY:
		_value *= 10
		_value += no
		_modifier.set_bit(2, 0, false)
		timer.start()

func set_keyboard_space(no: int) -> void:
	if not _modifier.get_bit(0, 0):
		set_code_focus(no)
	elif no == space:
		items[0].grab_focus()

func set_keyboard(event: InputEventKey) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	if event.keycode == KEY_CTRL:
		_modifier.set_bit(0, 0, event.is_pressed())
	elif text.is_valid_int():
		set_keyboard_space(int(text))
	else:
		match event.keycode:
			KEY_HOME: items[0].grab_focus()
			KEY_END: items[-1].grab_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		set_gamepad_button(event)
	elif event is InputEventJoypadMotion:
		set_gamepad_motion(event)
	elif event is InputEventKey:
		set_keyboard(event)
