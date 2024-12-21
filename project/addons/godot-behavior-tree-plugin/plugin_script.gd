@tool

extends EditorPlugin

func _get_types() -> Array[String]:
	return [
		"Tree", "Action", "Blackboard", "Condition", "Failer",
		"Inverter", "Limiter", "Repeater", "RepeatUntilFail",
		"RepeatUntilSuccess", "Selector", "MemSelector",
		"Sequence", "MemSequence", "Succeeder", "Wait"
	]

func _prefix(type: String) -> String: return "Behavior" + type

func _enter_tree():
	var plugin: String = "res://addons/godot-behavior-tree-plugin/%s/%s%s"

	for type in _get_types():
		var p: String = type.to_lower()
		var source: Variant = load(plugin % [p, p, ".gd"])
		var icon: Variant = load(plugin % [p, p, "_icon.png"])
		add_custom_type(_prefix(type), "Node", source, icon)

func _exit_tree():
	for type in _get_types(): remove_custom_type(_prefix(type))
