extends Node

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard

var enabled: bool = false

func play_progress() -> void:
	behavior.tick(self, board)

func on_toggle(toggled: bool) -> void:
	enabled = toggled
	print(name + " enabled: ", enabled)

func set_playback(options: Node) -> void:
	behavior.set_playback(options)

func _set_common(flags: Dictionary) -> void:
	board.set_value("rampage", flags.rampage)
	board.set_value("event", flags.event)

func _set_level(flags: Dictionary) -> void:
	board.set_value("level", flags.active)
	board.set_value("level_type", flags.type)
	board.set_value("level_name", flags.name)

func _set_progress(progress: Dictionary) -> void:
	_set_level(progress.level)
	_set_common(progress)

func as_theme(entry: Dictionary) -> void:
	if not enabled: return
	player.load_music(entry.ost[entry.i])
	_set_progress(entry.progress)

func as_ambient(entry: Dictionary, status: String) -> void:
	if not enabled: return
	player.load_music(entry.ost[entry.i][status])
	_set_progress(entry.progress)
