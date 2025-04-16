extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

var _ui: VBoxContainer
var _options: Node

func selection(query: SoundtrackTreeQuery) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: SoundtrackTreeQuery) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func setup() -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: SoundtrackTreeQuery = SoundtrackTreeQuery.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(_ui.dropdown)
		query.set_ui_tree(_options.ui)
		enumerate(query)
		_options.setup()

func reset() -> void:
	for leaf in _ui.dropdown.get_children():
		_ui.dropdown.remove_child(leaf)
		leaf.queue_free()
	SoundtrackSystem.reset()
	setup()

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	_options = options
	_ui = ui
	setup()
	if SoundtrackSystem.is_valid("music"):
		options.set_operations(_ui)
