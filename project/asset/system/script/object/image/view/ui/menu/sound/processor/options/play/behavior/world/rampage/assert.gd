extends BehaviorAction

const RAMPAGE: int = 1
var key: String = "rampage"

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, RAMPAGE + 1)

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.compare(key, RAMPAGE) else FAILED
