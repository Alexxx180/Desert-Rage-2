extends BehaviorAction

enum { MIN = 0, MAX = 100 }

func set_rampage(board: BehaviorBlackboard) -> void:
	var value: int = board.get_value("rampage")
	board.set_value("rampage", value + 1)

func skip_track(mix: int) -> bool:
	return mix == MIN or (mix != MAX and randi_range(mix, MAX) != MAX)

func tick(mark: Tick) -> int:
	var hero: Dictionary = SoundtrackSystem.user.world.rampage.name
	if skip_track(hero.mix): return FAILED
	
	mark.actor.player.load_music(hero.set.ray)
	set_rampage(mark.blackboard)
	return OK
