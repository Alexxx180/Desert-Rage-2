extends BehaviorTreeBase

class_name BehaviorSelector

"""
	Composite Node. Ticks children until one
	returns OK or ERR_BUSY. Fails ONLY if all
	children fail (return FAILED)
"""
func tick(mark: Tick) -> int:
	var code: int = FAILED
	var count: int = get_child_count()
	var i: int = -1
	
	while i < count and code == FAILED:
		i += 1
		code = get_child(i)._execute(mark)

	return OK if count == 0 else code
