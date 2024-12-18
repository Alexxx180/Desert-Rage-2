@tool
extends BehaviorDecorator

class_name BehaviorRepeater

"""
	Decorator Node. Repeats the same node until we either
	get a busy response. This node ignores failed and OK
	responses, choosing to retick the node instead
"""
func tick(mark: Tick) -> int:
	for child in get_children(): # 0..1 children
		while not child.tick(mark) == ERR_BUSY: pass
		return ERR_BUSY
	
	return OK
