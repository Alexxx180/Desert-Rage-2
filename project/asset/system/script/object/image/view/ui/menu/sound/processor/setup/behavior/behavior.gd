extends BehaviorAction

class_name SountrackBranchBehavior

func condition(_data: Variant) -> bool: return true
func branch(mark: Tick) -> int: return OK

func tick(mark: Tick) -> int:
	var context: Variant = mark.blackboard.get_value("query").get_context()
	if condition(context):
		return branch(mark)
	return FAILED
