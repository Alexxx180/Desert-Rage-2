extends BehaviorSequence

func set_playback(options: Node) -> void:
	for dungeon in get_children():
		dungeon.set_playback(options)
