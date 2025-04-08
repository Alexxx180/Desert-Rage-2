extends BehaviorAction

var rampage: int = BossSoundtrack.RAMPAGE
var has_boss: bool = false
var caption: String

func tick(mark: Tick) -> int:
	if not has_boss: return FAILED

	var value: int = mark.blackboard.get_value("rampage")
	if value == rampage:
		mark.blackboard.set_value("rampage", value + 1)
		return OK

	return FAILED
