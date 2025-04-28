extends Node

var _special: Callable = set_focus
var special: bool:
	set(value):
		if value: _special = set_special
		else: _special = set_focus

enum TRIGGER { LEFT = 4, RIGHT = 5 }
enum BUTTON { LEFT = 9, RIGHT = 10, Y = 2, X = 3 }

func set_active(active: int, is_pressed: bool, mods: Node) -> void:
	mods.set_bit(active, is_pressed)
	if is_pressed:
		mods.set_bit(active + 2, true)

func set_base(base: int, active: Vector2i, event: InputEvent, timing: Node) -> void:
	if timing.mods.get_bit(active.x):
		timing.set_focus(base + 3)
	else:
		set_active(active.y, event.is_pressed(), timing.mods)
		timing.start_timers()

func set_focus(timing: Node, modifier: int, space: int = 0) -> void:
	var base: int = timing.mods.get_trigger()
	if base != -1:
		timing.set_focus(base + modifier)
	else:
		timing.mods.space = modifier + space
		timing.start_timers()

func set_special(timing: Node, modifier: int, space: int = 0) -> void:
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
