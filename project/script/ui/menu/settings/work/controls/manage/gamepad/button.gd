extends Node

var manage: Node

enum { S = -1, E = 1, MAX = 4 }

func c(e: InputEvent) -> int: return e.axis

func completed() -> bool:
	return manage.next.size() < MAX

func finish(buttons: Array) -> void:
	manage.finish(buttons)

func add_buttons(state: bool, button: Variant) -> void:
	if state:
		manage.next.append(button)
	else:
		finish(manage.next)

func from_axis(event: InputEventJoypadMotion) -> Array:
	return [c(event), event.axis_value]

func add_ax(axis: int, value: int) -> Node:
	manage.next.append([axis, value])
	return self

func add_axs(x: int, y: int) -> void:
	add_ax(x, S).add_ax(y, S).add_ax(x, E).add_ax(y, E)

func auto_ax(event: InputEvent, ax: Array) -> void:
	for a in ax: if c(event) in ax:
		add_axs(a[0], a[1]); return

func all_axis(event: InputEvent) -> bool:
	manage.next.clear()
	auto_ax(event, [
		[JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
		[JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
	])
	manage.finish(manage.next)
	return true
