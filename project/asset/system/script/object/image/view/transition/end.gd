extends CanvasLayer

var _scene: String

@onready var player: AnimationPlayer = $player

func start_transition(level: String, _floor_diff: int = 0) -> void:
	_scene = level
	player.play("level_transitions/stairs_down_start")

func end_transition() -> void:
	print_debug(get_tree().call_deferred("change_scene_to_file", _scene))
