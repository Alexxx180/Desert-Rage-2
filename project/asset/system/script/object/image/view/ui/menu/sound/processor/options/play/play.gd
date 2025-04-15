extends Node

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard

func play_progress() -> void:
	behavior.tick(self, board)

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)
	board.reset()

func as_theme(entry: Dictionary, ui: Control) -> void:
	print("PLAY START")
	entry.theme.at = ui.i
	player.load_music(entry.theme.set[ui.i])
	entry.play.call(board, ui)
	print("PLAY FINISH")

func as_named(entry: Dictionary, ui: Control) -> void:
	print("PLAY START")
	player.load_music(entry.theme[ui.event.name])
	entry.play.call(board, ui)
	print("PLAY FINISH")

func as_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	entry.theme.at = ui.i
	player.load_music(entry.theme.set[ui.i][status])
	var rampage: int = 3
	match status:
		"ambient": rampage = 0
		"heating": rampage = 1
		"rampage": rampage = 2
	board.set_value("rampage", rampage)
	entry.play.call(board)
