@tool
extends BehaviorDecorator

class_name BehaviorSucceeder

""" Decorator Node. Always returns OK if not running or errored """

func tick(mark: Tick) -> int:
	var busy: bool = false
	var count: int = get_child_count()
	var i: int = -1
	
	while i < count and not busy:
		i += 1
		busy = get_child(i)._execute(mark) == ERR_BUSY

	return ERR_BUSY if busy else OK 
