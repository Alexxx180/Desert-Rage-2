extends BehaviorAction

enum { MIN = 0, MAX = 100, RAMPAGE = 1 }

func skip_track(mix: int) -> bool:
	return mix == MIN or (mix != MAX and randi_range(mix, MAX) != MAX)

func tick(mark: Tick) -> int:
	var hero: Dictionary = SoundtrackSystem.user.world.rampage.name
	if skip_track(hero.mix): return FAILED
	
	mark.actor.player.load_music(hero.set.ray)
	mark.blackboard.set_value("rampage", RAMPAGE + 1)
	return OK

func set_playback(options: Node, progress: Dictionary) -> void:
	progress.rampage = RAMPAGE
	var named: Array[Node] = get_children()
	var i: int = named.size()
	while i > 1:
		i -= 1
		named[i].set_playback(options, progress.duplicate())
