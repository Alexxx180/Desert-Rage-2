extends VBoxContainer

var preview: HelpPreview: set = set_preview

#@onready var help: Button = $help
@onready var motion: VBoxContainer = $scroll/motion
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

func toggle_help() -> void: #motion.toggle_hints()
	var state: bool = blackboard.get_value("hide")
	blackboard.set_value("hide", !state)
	behavior.tick(self, blackboard)

func progress(hint: String, act: String) -> void:
	blackboard.get_value("preview")[hint][act] = true

func set_preview(prev: HelpPreview) -> void:
	var group: Node2D = get_node("../../../../../../group")
	var analyze: Dictionary = group.camera.analyze.get_analyze()
	blackboard.set_value("hide", true)
	blackboard.set_value("show", prev.clone())
	
	blackboard.set_value("preview", prev.help)
	blackboard.set_value("analyze", analyze)
	
	blackboard.set_value("ref", {
		"motion": motion.get_category()
	})
	#motion.show_help_button.connect(_on_hide)
