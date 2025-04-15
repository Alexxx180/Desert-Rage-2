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

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)

func as_theme(entry: Dictionary, ui: Control) -> void:
	if enabled:
		print("PLAY START")
		entry.theme.at = ui.i
		player.load_music(entry.theme.set[ui.i])
		entry.play.call(board, ui)
		print("PLAY FINISH")

func as_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	if enabled:
		entry.theme.at = ui.i
		player.load_music(entry.theme.set[ui.i][status])
		var rampage: int = 3
		match status:
			"ambient": rampage = 0
			"heating": rampage = 1
			"rampage": rampage = 2
		board.set_value("rampage", rampage)
		entry.play.call(board)
