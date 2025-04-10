extends BehaviorActionPlayback

class_name BehaviorLevelProgress

static func get_dungeons() -> Array[Vector2i]:
	return [
		Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2),
		Vector2i(0, 3), Vector2i(1, 0)
	]

func set_dungeon(board: BehaviorBlackboard, dungeon: Vector2i) -> void:
	board.set_value("level_type", dungeon.x)
	board.set_value("level_name", dungeon.y)

func set_progress(board: BehaviorBlackboard) -> void:
	var dungeons: Array[Vector2i] = get_dungeons()
	var progress: int = (board.get_value("progress") + 1) % dungeons.size()
	
	set_dungeon(board, dungeons[progress])
	board.set_value("level", true)
	board.set_value("progress", progress)
	board.set_value("rampage", 0)
