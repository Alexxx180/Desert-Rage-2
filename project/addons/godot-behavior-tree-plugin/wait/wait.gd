extends "res://addon/godot-behavior-tree-plugin/base/decorator.gd"

@export var wait_time: float = 1.0

var _tick_time: float = 0.0

func enter(_mark: Tick) -> void:
	_tick_time = wait_time

func _process(delta:float):
	_tick_time -= delta

func is_waiting() -> bool:
	return _tick_time > 0.0

func reset_wait():
	_tick_time = wait_time

func tick(mark: Tick) -> int:
	var result: int = ERR_BUSY

	if is_waiting(): return result

	for child in get_children():
		result = child.tick(mark)
		reset_wait()
		return result

	return result # Timer still ticking
