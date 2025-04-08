extends BehaviorSelector

func set_playback(options: Node) -> void:
	var progress: Dictionary = {
		"level": { 
			"active": false,
			"type": 0, "name": 0
		},
		"rampage": 0, "event": 0
	}
	for dungeon in get_children():
		dungeon.set_playback(options, progress.duplicate())
