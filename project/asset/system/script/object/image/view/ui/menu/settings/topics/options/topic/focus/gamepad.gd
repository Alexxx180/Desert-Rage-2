extends Node

var _system: int = 6
var _special: Callable = set_focus
var special: bool:
	set(value):
		if value:
			_system = 4
			_special = set_special
		else:
			_system = 6
			_special = set_focus

enum TRIGGER { LEFT = 4, RIGHT = 5 }
enum BUTTON { LEFT = 9, RIGHT = 10, Y = 2, X = 3 }

func set_active(active: int, is_pressed: bool, mods: Node) -> void:
	mods.set_bit(active, is_pressed)
	mods.set_bit(5, true)

func set_base(base: int, active: Vector2i, event: InputEvent, timing: Node) -> void:
	if event.is_pressed():
		if timing.mods.get_bit(active.x):
			timing.mods.set_bit(5, false)
			timing.set_focus(base + 3)
		else:
			set_active(active.y, true, timing.mods)
			timing.start_timers()
	elif event.is_released():
		timing.mods.set_bit(active.y, false)
		if not timing.mods.get_bit(active.x) and timing.mods.get_bit(5):
			timing.mods.set_bit(5, false)
			timing.mods.space_trigger.emit(active.y + 2, _system)

func set_focus(timing: Node, modifier: int, space: int = 0) -> void:
	timing.mods.set_bit(5, false)
	var base: int = timing.mods.get_trigger()
	if base != -1:
		timing.set_focus(base + modifier)
	else:
		timing.mods.space = modifier + space
		timing.start_timers()

func set_special(timing: Node, modifier: int, space: int = 0) -> void:
	timing.mods.set_bit(5, false)
	var base: int = timing.mods.get_trigger()
	if base == -1:
		match modifier:
			4: timing.first.emit()
			5: timing.last.emit()
	else:
		timing.set_focus(base + modifier)

func set_button(event: InputEventJoypadButton, focus: Node) -> void:
	if event.is_pressed():
		match event.button_index:
			BUTTON.LEFT: set_focus(focus.timing, 1)
			BUTTON.RIGHT: set_focus(focus.timing, 2)
			BUTTON.X: _special.call(focus.timing, 4, 1)
			BUTTON.Y: _special.call(focus.timing, 5, 1)

func set_motion(event: InputEventJoypadMotion, focus: Node) -> void:
	match event.axis:
		TRIGGER.LEFT: set_base(5, Vector2i(2, 1), event, focus.timing)
		TRIGGER.RIGHT: set_base(0, Vector2i(1, 2), event, focus.timing)
