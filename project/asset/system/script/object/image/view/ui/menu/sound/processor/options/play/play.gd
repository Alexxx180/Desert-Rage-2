extends Node

signal playback(status: String)

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var change: Node = $change

var started = false

func set_playback(status: String) -> void: playback.emit(status)

func set_menu_context(menu: VBoxContainer) -> void:
	menu.options.back.pressed.connect(save_changes(menu))
	playback.connect(func(status): menu.playback.text = status)
	board.progress.connect(func(value): menu.progress.value = value)

func save_changes(menu: VBoxContainer) -> Callable:
	return func():
		started = false ; player.stop() ; board.reset()
		menu.playback.reset()
		SoundtrackSystem.save_changes()

func pause() -> void: player.stream_paused = true

func play_progress() -> void:
	behavior.tick(self, board)
	board.update_progress()

func start_play() -> void:
	if started:
		player.stream_paused = false #player.play()
	else:
		play_progress()
		started = true

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)
	board.reset()

func as_theme(entry: Dictionary, ui: Control) -> void: change.as_theme(entry, ui)
func as_named(entry: Dictionary, ui: Control) -> void: change.as_named(entry, ui)
func as_blend(entry: Dictionary, ui: Control) -> void: change.as_blend(entry, ui)
func as_ambient(entry: Dictionary, status: String, ui: Control) -> void: change.as_ambient(entry, ui, status)
