extends BehaviorSelector

func set_dungeons(feedback: Callable) -> void:
	for dungeon in get_children():
		feedback.call(dungeon)
