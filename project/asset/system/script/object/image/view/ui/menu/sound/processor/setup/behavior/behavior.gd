extends BehaviorAction

class_name SountrackBranchBehavior

func condition(_data: Variant) -> bool: return true
func branch(mark: Tick) -> int: return OK

func tick(mark: Tick) -> int:
	if condition(mark.blackboard.get_value("query").context):
		return branch(mark)
	return FAILED
