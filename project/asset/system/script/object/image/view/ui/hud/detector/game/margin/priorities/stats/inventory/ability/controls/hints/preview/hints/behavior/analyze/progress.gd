extends BehaviorAction

const EMPTY: String = ""

func tick(mark: Tick) -> int:
	var board: BehaviorBlackboard = mark.blackboard
	var head: String = board.g("head")
	if head == EMPTY: return FAILED
	
	var body: String = board.g("body")
	var ref: PanelContainer = board.g("ref")[head][body]
	ref.show_delayed()
	
	board.g("preview")[head][body] = true
	board.s("head", EMPTY).s("body", EMPTY)
	return OK
