@tool
extends BehaviorDecorator

class_name BehaviorLimiter

""" Decorator Node. Limits calls to same node. """

@export var max_calls: int = 0
var total_calls: int = 0

func tick(_mark: Tick) -> int: # Decorator Node
	if total_calls >= max_calls: return FAILED

	for child in get_children(): # 0..1 children
		total_calls += 1
		return child._execute(tick)

	return FAILED
