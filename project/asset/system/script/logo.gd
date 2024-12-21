extends ColorRect

@onready var timer: Timer = $show
@onready var state: TextureRect = $logo
@onready var tree = get_tree()

@export_file var scene: String = "res://asset/system/scene/usable/level/caves/origin/0/0/level.tscn"
@export var i: int = -1

var time: Array[Vector2] = [Vector2(1.5, 2), Vector2(2.5, 1)]

func _change_state(tint: Color) -> void:
	create_tween().tween_property(state, "modulate", tint, time[i].x)

func _input(event: InputEvent) -> void:
	if not i in [0, 1]: return
	var gamepad: bool = event is InputEventJoypadButton
	var mouse: bool = event is InputEventMouseButton
	
	if (gamepad or mouse or event is InputEventKey) and event.pressed:
		state.hide()
		_scene_change()

func _scene_change() -> void:
	timer.stop()
	print_debug(tree.change_scene_to_file(scene))

func _show() -> void:
	i += 1
	match i:
		0: _change_state(Color.WHITE)
		1: _change_state(Color.BLACK)
		_: _scene_change(); return
	timer.wait_time = time[i].x + time[i].y
	timer.start()
