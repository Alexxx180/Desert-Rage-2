@tool
extends BehaviorDecorator

class_name BehaviorFailer

""" Decorator node. Always returns FAILED if not running """

func tick(mark: Tick) -> int:
	var i: int = -1
	var result: bool = true
	var count: int = get_child_count() - 1

	while i < count and result:
		i += 1
		result = get_child(i)._execute(mark) != ERR_BUSY

	return FAILED if result else ERR_BUSY
