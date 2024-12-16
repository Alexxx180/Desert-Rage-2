extends Node

""" Behavior tree dictionary storage """

var _base_memory: Dictionary # global info
var _tree_memory: Dictionary # node-tree info

func _enter_tree() -> void:
	_base_memory = {}
	_tree_memory = {}

func set_value(key, value, behavior_tree = null, node_scope = null) -> void:
	var memory := _get_memory(behavior_tree, node_scope)
	memory[key] = value

func get_value(key, behavior_tree = null, node_scope = null) -> Variant:
	var memory := _get_memory(behavior_tree, node_scope)
	return memory[key] if memory.has(key) else null

func _extract(behavior_tree: Variant, node_scope) -> Dictionary:
	var memory: Dictionary = _get_tree_memory(behavior_tree)
	if node_scope:
		memory = _get_node_memory(memory, node_scope)
	return memory

func _get_memory(behavior_tree: Variant, node_scope) -> Dictionary:
	if behavior_tree:
		return _extract(behavior_tree, node_scope)
	return _base_memory

func _get_tree_memory(behavior_tree: Variant) -> Dictionary:
	if not _tree_memory.has(behavior_tree):
		_tree_memory[behavior_tree] = { "nodeMemory": {}, "openNodes": [] }
	return _tree_memory[behavior_tree]

func _get_node_memory(tree_memory: Dictionary, node_scope: Variant) -> Dictionary:
	var memory: Dictionary = tree_memory['nodeMemory']
	if not memory.has(node_scope): memory[node_scope] = {}
	return memory[node_scope]
