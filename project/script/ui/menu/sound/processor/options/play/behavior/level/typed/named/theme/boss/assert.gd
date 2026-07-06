extends AmbientPlaybackAssert

var has_boss: bool = false

func compare(board: BehaviorBlackboard) -> bool:
	return has_boss and board.compare(key, rampage)
