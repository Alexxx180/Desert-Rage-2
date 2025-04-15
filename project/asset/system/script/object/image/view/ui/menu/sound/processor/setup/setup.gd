extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

func selection(query: SoundtrackTreeQuery) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: SoundtrackTreeQuery) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: SoundtrackTreeQuery = SoundtrackTreeQuery.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(ui.dropdown)
		query.set_ui_tree(options.ui)
		enumerate(query)
		options.setup(ui.options)
