extends BehaviorAction

const PROBABILITY: int = 100

func _set_track(mark: Tick, hero: Dictionary) -> void:
	mark.actor.player.load_music(hero.ray)

func tick(mark: Tick) -> int:
	var hero: Dictionary = SoundtrackSystem.user.world.rampage.name
	if hero.mix == 0: return FAILED
	if hero.mix == 1 or randi_range(hero.mix, PROBABILITY) == PROBABILITY:
		_set_track(mark, hero.set)
		return OK
	return FAILED
