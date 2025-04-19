extends Node

@onready var save: SavePresetDialog = $save
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $board
@onready var branch: Node = $branch

func selection(query: ExportOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: ExportOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func _export(path: String) -> void:
	if branch.zip.start_write(path) == OK:
		var query: ExportOST = ExportOST.new()
		query.result = {}
		query.set_user(SoundtrackSystem.user.music)
		query.set_path("")
		enumerate(query)
		branch.zip.manifest(query.result)
		branch.zip.stop_write()

func exporting() -> void:
	save.show_dialog(_export)
