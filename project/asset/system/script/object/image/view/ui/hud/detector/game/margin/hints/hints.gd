extends VBoxContainer

var preview: HelpPreview: set = set_preview

@onready var analyze: Button = $analyze
@onready var motion: VBoxContainer = $scroll/motion
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func progress(hint: String, act: String) -> void:
	blackboard.set_value("hide", true)
	behavior.tick(self, blackboard)
	blackboard.get_value("preview")[hint][act] = true
	blackboard.set_value("hide", false)
	behavior.tick(self, blackboard)

func set_preview(prev: HelpPreview) -> void:
	var group: Node2D = get_node("../../../../../../group")
	var help: Dictionary = group.camera.analyze.get_analyze()
	var ref: Dictionary = {
		"motion": motion.get_category()
	}
	blackboard.set_values(
		["hide", "show", "preview", "analyze", "ref"],
		[true, prev.clone(), prev.help, help, ref]
	)
