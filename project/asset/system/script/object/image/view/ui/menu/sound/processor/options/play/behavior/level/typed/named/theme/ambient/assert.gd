extends BehaviorAction

var rampage: int = BossSoundtrack.RAMPAGE
var has_boss: bool = false
var caption: String

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if has_boss and mark.blackboard.compare(key, rampage):
		mark.blackboard.set_value(key, rampage + 1)
		return OK
	return FAILED
