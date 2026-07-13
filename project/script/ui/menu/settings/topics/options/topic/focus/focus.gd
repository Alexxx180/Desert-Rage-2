extends Node

@onready var timing: Node = $timing
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func setup_items(items: Node) -> void:
	timing.space_trigger.connect(items.set_space)
	timing.first.connect(items.first)
	timing.last.connect(items.last)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		gamepad.set_button(event, self)
	if event is InputEventJoypadMotion:
		gamepad.set_motion(event, self)
	if event is InputEventKey:
		keyboard.set_focus(event, self)


extends Node

signal space_trigger(selection: int, system: int)
signal select(value: int)
signal preview(value: int)
signal first()
signal last()

@onready var finish: Timer = $finish
@onready var action: ActionTimer = $action
@onready var mods: Node = $mods

var MAX: int = 100
var _value: int = 0

func next_digit() -> int: return _value * 10
func set_first() -> void: first.emit()
func set_last() -> void: last.emit()
func set_space(selection: int, system: int) -> void:
	space_trigger.emit(selection, system)

func set_number(no: int) -> void:
	_value = next_digit() + no
	mods.set_bit(0, false)
	#mods.set_bit(5, false)
	#mods.space = 0
	preview.emit(_value)

func start_timers() -> void:
	finish.start()
	action.start()

func set_focus(no: int) -> void:
	if mods.get_bit(0) and next_digit() < MAX:
		set_number(no)
		start_timers()

func _ready() -> void:
	action.timeout.connect(_continue_input)

func _continue_input() -> void:
	action.stop()
	mods.allow_input()

func _reset() -> void:
	print("VALUE: ", _value)
	if _value != 0:
		select.emit(_value)
		_value = 0



extends Node

#signal space_trigger(modifier: int, system: int)

var _modifier: BitMap = BitMap.new()
#var space: int = 0
# var system: int = 4

enum ACTIVE { LEFT = 1, RIGHT = 2 }

func _ready() -> void:
	_modifier.create(Vector2i(6, 1))
	allow_input()

func get_bit(pos: int) -> bool:
	return _modifier.get_bit(pos, 0)

func set_bit(pos: int, bit: bool) -> void:
	_modifier.set_bit(pos, 0, bit)

func allow_input() -> void:
	set_bit(0, true)
	#check_spaces()

#func set_space(selection: int, system: int) -> void:
	#space_trigger.emit(selection, system)

"""
func check_spaces() -> void:
	if space != 0:
		space_trigger.emit(space, system)
		space = 0
"""

func get_trigger() -> int:
	if get_bit(ACTIVE.LEFT): return 0
	if get_bit(ACTIVE.RIGHT): return 5
	return -1



extends Node

func set_space(text: String, key: String, timing: Node) -> void:
	text = text.replace(key, "")
	if text.is_valid_int():
		timing.set_space(int(text), 10)

func special_focus(key: int, timing: Node) -> void:
	match key:
		KEY_HOME: timing.set_first()
		KEY_END: timing.set_last()

func set_focus(event: InputEventKey, focus: Node) -> void:
	var text: String = event.as_text().replace("Kp ", "")
	var key: String = "Ctrl+"
	var timing: Node = focus.timing
	
	if text.contains(key):
		set_space(text, key, timing)
	elif text.is_valid_int():
		timing.set_focus(int(text))
	else:
		special_focus(event.keycode, timing)



extends Node

var _system: int = 6
var _special: Callable = set_focus
var special: bool:
	set(value):
		if value: _set_system_for_special(4, set_special)
		else: _set_system_for_special(6, set_focus)

enum { LT = 4, RT = 5, LB = 9, RB = 10, Y = 2, X = 3 }

func _set_system_for_special(digits: int, feedback: Callable) -> void:
	_system = digits
	_special = feedback

func _set_axis_pressed(timing: Node, active: Vector2i, base: int) -> void:
	var is_based: bool = timing.mods.get_bit(active.x)
	if is_based:
		timing.set_focus(base + 3)
	else:
		timing.mods.set_bit(active.x, true)
		timing.start_timers()
	timing.mods.set_bit(5, !is_based)

func _set_axis_released(timing: Node, active: Vector2i) -> void:
	timing.mods.set_bit(active.y, false)
	if not timing.mods.get_bit(active.x) and timing.mods.get_bit(5):
		timing.mods.set_bit(5, false)
		timing.set_space(active.y + 2, _system)

func set_base(base: int, active: Vector2i, event: InputEvent, timing: Node) -> void:
	if event.is_pressed():
		_set_axis_pressed(timing, active, base)
	elif event.is_released():
		_set_axis_released(timing, active)

func set_based_focus(timing: Node, modifier: int) -> bool:
	timing.mods.set_bit(5, false)
	var base: int = timing.mods.get_trigger()
	var is_based: bool = base != -1
	if is_based: timing.set_focus(base + modifier)
	return is_based

func set_focus(timing: Node, modifier: int) -> void:
	if not set_based_focus(timing, modifier):
		timing.set_space(modifier + 1, _system)
		#timing.mods.space = modifier + space
		#timing.start_timers()

func set_special(timing: Node, modifier: int) -> void:
	if set_based_focus(timing, modifier):
		match modifier:
			4: timing.first.emit()
			5: timing.last.emit()

func set_button(event: InputEventJoypadButton, focus: Node) -> void:
	if event.is_pressed():
		match event.button_index:
			LB: set_focus(focus.timing, 1)
			RB: set_focus(focus.timing, 2)
			X: _special.call(focus.timing, 4)
			Y: _special.call(focus.timing, 5)

func set_motion(event: InputEventJoypadMotion, focus: Node) -> void:
	match event.axis:
		LT: set_base(5, Vector2i(2, 1), event, focus.timing)
		RT: set_base(0, Vector2i(1, 2), event, focus.timing)
