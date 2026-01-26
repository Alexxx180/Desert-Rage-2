extends VBoxContainer

@onready var kind: VBoxContainer = $category
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func clear_progress() -> void:
	for type in ["motion", "action", "reason"]:
		for ref in blackboard.g("ref")[type].values():
			if ref.visible: ref.hide_delayed()

func progress(head: String, body: String) -> void:
	behavior.tick(self, blackboard.s("head", head).s("body", body))

func set_preview(group: Node2D, prev: HelpPreview) -> void:
	var help: Dictionary = group.camera.analyze.get_analyze()
	blackboard.s("hide", true).s("show", prev.clone()).s("ref", {
		"motion": kind.motion.get_category(),
		"action": kind.action.get_category(),
		"reason": kind.reason.get_category()
	}).s("progress", []).s("preview", prev.help).s("analyze", help)
