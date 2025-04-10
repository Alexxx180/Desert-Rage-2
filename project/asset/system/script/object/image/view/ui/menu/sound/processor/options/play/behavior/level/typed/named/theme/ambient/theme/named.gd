extends BehaviorActionPlayback

var caption: int = 0

func mod_path(path: Array[String]) -> Array[String]:
	path.insert(2, "name")
	return path

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	var path: Array[String] = mod_path(progress.path)
	return SoundtrackSystem.get_value(options.ui, path)

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context.duplicate())

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if mark.blackboard.compare(key, caption):
		mark.actor.player.load_music(_context.set[0])
		mark.blackboard.set_value(key, caption + 1)
		return OK
	return FAILED
