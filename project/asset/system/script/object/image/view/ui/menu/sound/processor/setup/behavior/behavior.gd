extends BehaviorAction

class_name SountrackBranchBehavior

func condition(_data: Variant) -> bool: return true
func branch(_setup: Node, _context: Variant) -> int: return OK

func tick(mark: Tick) -> int:
	var board: BehaviorBlackboard = mark.blackboard
	var context: Variant = board.get_value("context")
	if condition(context):
		return branch(board.get_value("setup"), context)
	return FAILED
