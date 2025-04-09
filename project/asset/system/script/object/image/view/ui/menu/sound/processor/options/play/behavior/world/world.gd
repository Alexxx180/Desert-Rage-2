extends BehaviorSelector

func set_playback(options: Node, progress: Dictionary) -> void:
	for dungeon in get_children():
		dungeon.set_playback(options, progress.duplicate())
