extends BehaviorTreeBase

class_name BehaviorSequence

"""
	Composite Node - ticks children until one
	returns FAILED or ERR_BUSY. Succeeds ONLY
	if all children succeed (return OK)
"""
func tick(mark: Tick) -> int:
	var code: int = OK
	var count: int = get_child_count() - 1
	var i: int = -1
	
	while i < count and code == OK:
		i += 1
		code = get_child(i)._execute(mark)

	return code
