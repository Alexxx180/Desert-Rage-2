extends BehaviorAction

class_name AmbientPlaybackAssert

var rampage: int = 0
var key: String = "rampage"

func compare(board: BehaviorBlackboard) -> bool:
	return board.compare(key, rampage)

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, rampage + 1)

func tick(mark: Tick) -> int:
	if compare(mark.blackboard):
		# mark.blackboard.set_value(key, rampage + 1)
		return OK
	return FAILED
