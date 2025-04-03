extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

func selection(query: SoundtrackTreeQuery, key: String) -> void:
	board.set_value("query", query.select(key))
	behavior.tick(self, board)

func enumerate(query: SoundtrackTreeQuery) -> void:
	for key in query.context:
		selection(query.copy(), key)

func set_soundtrack(ui: HFlowContainer) -> void:
	var query: SoundtrackTreeQuery = SoundtrackTreeQuery.new()
	if query.init_manifest():
		query.set_ui(ui)
		enumerate(query)
