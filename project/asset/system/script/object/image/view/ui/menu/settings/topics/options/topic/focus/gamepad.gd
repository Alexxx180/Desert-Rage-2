extends Node

signal first()
signal last()

enum TRIGGER { LEFT = 4, RIGHT = 5 }
enum BUTTON { LEFT = 9, RIGHT = 10, Y = 2, X = 3 }

func set_base(base: int, active: Vector2i, event: InputEvent, timing: Node) -> void:
	if timing.mods.get_bit(active.x):
		timing.set_focus(base + 3)
	else:
		timing.mods.set_bit(active.y, event.is_pressed())

func set_focus(timing: Node, modifier: int, space: int = 0) -> void:
	var base: int = timing.mods.get_trigger()
	if base != -1:
		timing.set_focus(base + modifier)
	else:
		timing.start_timers()
	timing.mods.space = modifier + space

func set_button(event: InputEventJoypadButton, focus: Node) -> void:
	if event.is_pressed():
		match event.button_index:
			BUTTON.LEFT: set_focus(focus.timing, 1)
			BUTTON.RIGHT: set_focus(focus.timing, 2)
			BUTTON.X: set_focus(focus.timing, 4, 1)
			BUTTON.Y: set_focus(focus.timing, 5, 1)

func set_motion(event: InputEventJoypadMotion, focus: Node) -> void:
	#if event.is_pressed():
	match event.axis:
		TRIGGER.LEFT: set_base(5, Vector2i(2, 1), event, focus.timing)
		TRIGGER.RIGHT: set_base(0, Vector2i(1, 2), event, focus.timing)
