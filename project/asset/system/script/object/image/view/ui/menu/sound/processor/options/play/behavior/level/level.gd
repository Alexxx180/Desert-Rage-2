extends BehaviorSequence

func set_ost(music: Node) -> void:
	for dungeon in get_children():
		dungeon.set_ost(music)
