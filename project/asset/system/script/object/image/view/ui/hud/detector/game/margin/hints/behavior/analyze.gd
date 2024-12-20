extends BehaviorAction

func tick(mark: Tick) -> int:
	var can_show: bool = false
	var board: BehaviorBlackboard = mark.blackboard

	var preview: Dictionary = board.get_value("preview")
	var show: Dictionary = board.get_value("show")
	var analyze: Dictionary = board.get_value("analyze")

	for head in preview.keys():
		for body in preview[head].keys():
			show[head][body] = preview[head][body]
			if show[head][body] and analyze[head].has(body):
				show[head][body] = analyze[head][body].is_colliding()
			can_show = can_show or show[head][body]
	
	return OK if can_show else FAILED
