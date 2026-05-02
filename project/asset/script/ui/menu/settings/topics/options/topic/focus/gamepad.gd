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
