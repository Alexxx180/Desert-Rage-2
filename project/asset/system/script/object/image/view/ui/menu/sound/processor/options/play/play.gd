extends Node

signal playback(status: String)

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard

var started = false

func play_progress() -> void:
	behavior.tick(self, board)
	board.update_progress()

func start_play() -> void:
	if started:
		player.stream_paused = false
		#player.play()
	else:
		play_progress()
		started = true

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)
	board.reset()

func set_status(metadata: Dictionary) -> void:
	print("PLAYING!")
	var status: String = metadata.caption
	if metadata.has("name"):
		status = metadata.name + " - " + status
	match player.load_music(metadata.track):
		OK: playback.emit(status)
		FAILED: playback.emit(metadata.track + "? Missing: " + status)
		ERR_BUSY: playback.emit(metadata.track + " ≠ .mp3, .ogg: " + status)

func as_theme(entry: Dictionary, ui: Control) -> void:
	entry.theme.at = ui.i
	entry.play.call(board, ui)
	set_status({ "caption": ui.caption, "track": entry.theme.set[ui.i] })

func as_named(entry: Dictionary, ui: Control) -> void:
	entry.play.call(board, ui)
	set_status({ "caption": ui.caption, "name": ui.event.name, "track": entry.theme[ui.event.name] })

func as_blend(entry: Dictionary, ui: Control) -> void:
	entry.play.call(board, ui)
	set_status({ "caption": ui.caption, "name": ui.event.name, "track": entry.theme.set[ui.event.name] })

func as_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	entry.theme.at = ui.i
	var rampage: int = 3
	match status:
		"ambient": rampage = 0
		"heating": rampage = 1
		"rampage": rampage = 2
	board.set_value("level_rampage", rampage)
	entry.play.call(board, ui)
	set_status({ "caption": ui.content[status].caption, "name": status, "track": entry.theme.set[ui.i][status] })
