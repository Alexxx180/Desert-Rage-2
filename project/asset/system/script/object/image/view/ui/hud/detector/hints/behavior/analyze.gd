extends BehaviorAction

func tick(mark: Tick) -> int:
	var can_show: bool = false
	var board: BehaviorBlackboard = mark.blackboard
	var preview: Dictionary = board["preview"]
	
	for head in preview.keys():
		for body in preview[head].keys():
			board["show"][head][body] = preview[head][body] or board["detect"][head][body].is_colliding()
			can_show = can_show or board["show"][head][body]
	
	return OK if can_show else FAILED
