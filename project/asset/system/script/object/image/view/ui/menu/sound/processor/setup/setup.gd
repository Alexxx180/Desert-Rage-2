extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard

func enumerate() -> void:
	var query: SoundtrackTreeQuery = board.get_value("query")
	for key in query.get_context():
		board.set_value("query", query.copy().select(key))
		behavior.tick(self, board)

func set_soundtrack(ui: HFlowContainer) -> void:
	var query: SoundtrackTreeQuery = SoundtrackTreeQuery.new()
	if query.init_manifest():
		query.set_ui(ui)
		board.set_value("leaf", $leaf)
		board.set_value("query", query)
		enumerate()
