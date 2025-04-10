extends BehaviorActionPlayback

class_name HeroBattleTheme

enum { MIN = 0, MAX = 100, RAMPAGE = 1 }

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.rampage = HeroBattleTheme.RAMPAGE
	return {
		"ost": SoundtrackSystem.user.world.rampage.name,
		"ui": options.ui.world.rampage.name.set,
		"progress": progress
	}

func probable(mix: int) -> bool:
	return randi_range(mix, MAX) == MAX

func use_track(mix: int) -> bool:
	return mix != MIN and (mix == MAX or probable(mix))

func tick(mark: Tick) -> int:
	if use_track(_context.mix):
		mark.actor.player.load_music(_context.set.ray)
		mark.blackboard.set_value("rampage", RAMPAGE + 1)
		return OK
	return FAILED
