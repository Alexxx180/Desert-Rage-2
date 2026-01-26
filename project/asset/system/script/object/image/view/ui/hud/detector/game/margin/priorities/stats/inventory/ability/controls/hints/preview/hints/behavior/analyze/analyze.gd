extends BehaviorAction

func resolve_showcase(body, show, preview, analyze):
	print("preview: ", preview[body], ", body: ", body, ", collide: ", analyze.has(body) and analyze[body].is_colliding())
	show[body] = preview[body]
	if show[body] and analyze.has(body):
		show[body] = analyze[body].is_colliding()

func tick(mark: Tick) -> int:
	var can_show: bool = false
	var board: BehaviorBlackboard = mark.blackboard

	var preview: Dictionary = board.g("preview")
	var show: Dictionary = board.g("show")
	var analyze: Dictionary = board.g("analyze")

	for head in preview.keys():
		for body in preview[head].keys():
			can_show = can_show or resolve_showcase(
				body, show[head], preview[head], analyze[head])
	
	return OK if can_show else FAILED
