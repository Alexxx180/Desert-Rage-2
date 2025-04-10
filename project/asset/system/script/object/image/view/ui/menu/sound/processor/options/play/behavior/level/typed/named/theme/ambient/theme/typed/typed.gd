extends BehaviorActionPlayback

func mod_path(path: Array[String]) -> Array[String]:
	path[2] = "type"
	path.push_back("theme")
	return path

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.rampage = HeroBattleTheme.RAMPAGE
	var path: Array[String] = mod_path(progress.path)
	return SoundtrackSystem.get_value(options.ui, path)

func tick(mark: Tick) -> int:
	mark.actor.player.load_music(_context.set[0])
	return OK
