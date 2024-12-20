extends BehaviorAction

func tick(mark: Tick) -> int:
	var progress: Array = mark.blackboard.get_value("progress")
	
	if progress.size() == 0: return FAILED
	
	var head: String = progress[0]
	var body: String = progress[1]
	
	var ref: VBoxContainer = mark.blackboard.get_value("ref")[head][body]
	
	#print("IS AVAILABLE? ", available, " - HEAD: ", head, " - BODY: ", body)
	if progress.size() == 2:
		ref.show_delayed()
	else:
		ref.hide_delayed()
		progress.clear()
		return OK
	
	mark.blackboard.get_value("preview")[head][body] = true
	return OK
