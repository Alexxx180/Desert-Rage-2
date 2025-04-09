extends BehaviorSequence

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.level.active = true
	progress.path = ["level"]
	for dungeon in get_children():
		dungeon.set_playback(options, progress.duplicate())
