extends Node

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard

func set_playback(options: Node) -> void:
	behavior.set_playback(options)

func play_theme(tracks: Array, i: int, progress: Dictionary) -> void:
	player.load_music(tracks[i])
	board.set_value("level", progress.level.active)
	board.set_value("level_type", progress.level.type)
	board.set_value("level_name", progress.level.name)
	board.set_value("rampage", progress.rampage)
	board.set_value("event", progress.event)
