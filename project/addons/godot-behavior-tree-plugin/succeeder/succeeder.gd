@tool
extends BehaviorDecorator

class_name BehaviorSucceeder

""" Decorator Node. Always returns OK if not running or errored """

func tick(mark: Tick) -> int:
	var busy: bool = false
	var count: int = get_child_count()
	var i: int = 0
	
	while i < count and not busy:
		busy = get_child(i)._execute(mark) == ERR_BUSY
		i += 1

	return ERR_BUSY if busy else OK 
