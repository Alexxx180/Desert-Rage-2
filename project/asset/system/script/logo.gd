extends ColorRect

@onready var player: AnimationPlayer = $player
@onready var show: Timer = $show

@export_file var scene: String = "res://asset/system/scene/usable/level/caves/origin/0/0/level.tscn"

var progress: Array[int] = [1, 3, 1]
var events: Array = [
	InputEventJoypadButton, InputEventMouseButton, InputEventKey
]

func _input(event: InputEvent) -> void:
	if event in events: _scene_change()

func _get_ip() -> String: return "logo/appear"
func _scene_change() -> void:
	show.stop()
	print_debug(get_tree().change_scene_to_file(scene))

func _show() -> void:
	match progress[0]:
		1: player.play(_get_ip())
		2: player.play_backwards(_get_ip())
		_: _scene_change(); return

	show.wait_time = progress[progress[0]]
	show.start()
	progress[0] += 1
