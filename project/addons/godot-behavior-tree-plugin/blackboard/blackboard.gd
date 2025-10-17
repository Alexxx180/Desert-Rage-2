extends Node

class_name BehaviorBlackboard

""" Behavior tree dictionary storage """

var _base_memory: Dictionary = {} # global info
var _tree_memory: Dictionary = {} # node-tree info

func set_value(key, value, tree: BehaviorTree = null, scope: BehaviorTreeBase = null) -> void:
	_get_memory(tree, scope)[key] = value

func get_value(key, tree: BehaviorTree = null, scope: BehaviorTreeBase = null) -> Variant:
	var memory := _get_memory(tree, scope)
	return memory[key] if memory.has(key) else null

func add_value(key: String, value: int) -> void:
	set_value(key, get_value(key) + value)

func compare(key: Variant, value: Variant) -> bool:
	return get_value(key) == value

func _extract(memory: Dictionary, scope: BehaviorTreeBase) -> Dictionary:
	return _get_node_memory(memory, scope) if scope else memory

func _get_memory(tree: BehaviorTree, scope: BehaviorTreeBase) -> Dictionary:
	return _extract(_get_tree_memory(tree), scope) if tree else _base_memory

func make_exist(memory: Dictionary, key: Variant, value: Dictionary) -> Dictionary:
	if not memory.has(key): memory[key] = value
	return memory[key]

func _get_tree_memory(tree: BehaviorTree) -> Dictionary:
	return make_exist(_tree_memory, tree, { "nodeMemory": {}, "openNodes": [] })

func _get_node_memory(memory: Dictionary, scope: BehaviorTreeBase) -> Dictionary:
	return make_exist(memory['nodeMemory'], scope, {})
