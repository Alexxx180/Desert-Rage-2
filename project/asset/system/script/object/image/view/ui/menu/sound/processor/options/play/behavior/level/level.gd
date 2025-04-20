extends BehaviorSequence

func set_ost(music: Node) -> void:
	var dungeons: Array[Node] = get_children()
	var i: int = dungeons.size()
	while i > 1:
		i -= 1
		dungeons[i].set_ost(music)
