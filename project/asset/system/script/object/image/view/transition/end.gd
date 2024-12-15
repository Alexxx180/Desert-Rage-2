extends CanvasLayer

var scene: String

@onready var player: AnimationPlayer = $player

func start_transition(level: String) -> void:
	scene = level
	player.play("level_transitions/stairs_down_start")

func end_transition() -> void:
	print_debug(get_tree().call_deferred("change_scene_to_file", scene))
