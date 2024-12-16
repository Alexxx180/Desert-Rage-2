@tool
extends Node

const Tick = preload("res://addon/godot-behavior-tree-plugin/base/tick.gd")
const BehaviorBlackboard: GDScript = preload("res://addon/godot-behavior-tree-plugin/blackboard/blackboard.gd")

func warn() -> String:
	return "should have exactly one child"

func _ready() -> void:
	if not get_child_count() == 1:
		push_error("BehaviorTree '%s' %s." % [name, warn()])

func tick(actor: Variant, blackboard: BehaviorBlackboard, debug = false) -> int:
	var mark := Tick.new()
	mark.tree = self
	mark.actor = actor
	mark.blackboard = blackboard
	mark.debug = debug

	var result := FAILED
	for child in get_children():
		result = child._execute(mark)

	# Close nodes from last tick, if needed
	var last_open_nodes: Array = mark.blackboard.get_value('openNodes', self)
	var current_open_nodes := mark.open_nodes

	# If node isn't currently open, but was open during last tick, close it
	for node in last_open_nodes:
		if (not current_open_nodes.has(node) 
			and mark.blackboard.get_value('isOpen', mark.tree, node)):
				node._close(mark)

	# Populate the blackboard
	blackboard.set_value('openNodes', current_open_nodes, self)
	return result

func _notification(code: int) -> void:
	if code in [NOTIFICATION_PARENTED, NOTIFICATION_UNPARENTED]:
		update_configuration_warnings()

func _get_configuration_warning() -> String:
	if get_child_count() == 1: return ""
	return "A BehaviorTree " + warn()
