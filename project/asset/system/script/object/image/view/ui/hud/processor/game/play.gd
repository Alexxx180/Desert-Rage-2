extends Node

var _actions: bool = false

var hud: CanvasLayer
var options: HFlowContainer

@onready var skills: Node = $skills
@onready var tree: SceneTree = get_tree()

func _set_visible() -> void:
	_actions = !_actions
	options.skills.visible = _actions
	options.skills.init_focus()

func _set_process() -> void:
	tree.paused = _actions

func pressed() -> void:
	if skills.selection:
		skills.hide_aims()
		skills.panel.show()
	else:
		_set_visible()
		_set_process()
