extends BehaviorSelector

func set_ost(music: Node) -> void:
	var events: Array[Node] = get_children()
	var i: int = events.size() - 1
	while i > 0:
		i -= 1
		events[i].set_ost(music, i)
