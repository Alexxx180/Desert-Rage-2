extends VBoxContainer

@onready var kind: VBoxContainer = $category
@onready var behavior: BehaviorTree = $behavior
@onready var blackboard: BehaviorBlackboard = $blackboard

@export var casual: bool = false

var types: Array[String]

func _ready() -> void:
	kind.fight.visible = !casual

func toggle_help() -> void:
	blackboard.toggle_value("hide")
	behavior.tick(self, blackboard)

func clear_progress() -> void:
	for type in types:
		for ref in blackboard.g("ref")[type].values():
			if ref.visible: ref.hide_delayed()

func progress(head: String, body: String) -> void:
	behavior.tick(self, blackboard.s("head", head).s("body", body))

func get_category() -> Dictionary:
	var result: Dictionary = {}
	for i in kind.get_children():
		result[i.name] = i.get_category()
		types.append(i.name)
	return result

func set_preview(group: Node2D, prev: HelpPreview) -> void:
	var help: Dictionary = group.camera.analyze.get_analyze()
	blackboard.s("hide", true).s("show", prev.clone()).s("ref", get_category()).s(
		"progress", []).s("preview", prev.help).s("analyze", help)
