extends BehaviorActionPlayback

class_name HeroBattleTheme

enum { MIN = 0, MAX = 100, RAMPAGE = 1 }

func set_ost(music: Node) -> void:
	_ost = music.world.named.ost.rampage.theme

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or randi_range(mix, MAX) == MAX)

func tick(mark: Tick) -> int:
	if probable(_ost.mix):
		mark.actor.player.load_music(_ost.set.values().pick_random())
		mark.blackboard.set_value("rampage", RAMPAGE + 1)
		return OK
	return FAILED
