extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

var _ui: VBoxContainer
var _options: Node

func selection(query: TreeOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: TreeOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func setup() -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: TreeOST = TreeOST.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(_ui.dropdown)
		query.set_ui_tree(_options.ui)
		enumerate(query)
		_options.setup()

func _reload() -> void:
	for leaf in _ui.dropdown.get_children():
		_ui.dropdown.remove_child(leaf)
		leaf.queue_free()
	setup()

func reset() -> void:
	SoundtrackSystem.reset()
	_reload()

func reimport() -> void:
	SoundtrackSystem.reimport()
	_reload()

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	_options = options
	_ui = ui
	setup()
	if SoundtrackSystem.is_valid("music"):
		options.set_operations(_ui)
