extends VBoxContainer

var preview: HelpPreview: set = set_preview

@onready var motion: VBoxContainer = $scroll/category/motion
@onready var action: VBoxContainer = $scroll/category/action
@onready var reason: VBoxContainer = $scroll/category/reason

@onready var analyze: Button = $analyze
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func clear_progress() -> void:
	for type in ["motion", "action", "reason"]:
		for ref in blackboard.get_value("ref")[type].values():
			if ref.visible: ref.hide_delayed()

func progress(head: String, body: String) -> void:
	blackboard.get_value("progress").push_back(head)
	blackboard.get_value("progress").push_back(body)
	behavior.tick(self, blackboard)
	blackboard.get_value("progress").clear()

func set_preview(prev: HelpPreview) -> void:
	var group: Node2D = get_node("../../../../../../group")
	var help: Dictionary = group.camera.analyze.get_analyze()
	var ref: Dictionary = {
		"motion": motion.get_category(),
		"action": action.get_category(),
		"reason": reason.get_category()
	}
	blackboard.set_values(
		["hide", "show", "preview", "analyze", "ref", "progress"],
		[true, prev.clone(), prev.help, help, ref, []]
	)
	#print("HELP - 2: ", prev.clone())
	#print("HELP: ", ref)
