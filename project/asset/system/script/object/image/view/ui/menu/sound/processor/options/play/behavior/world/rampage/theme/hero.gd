extends BehaviorActionPlayback

class_name HeroBattleTheme

signal progress(mark: Tick)

enum { MIN = 0, MAX = 100 }

func set_ost(music: Node) -> void:
	_ost = music.world.named.ost.rampage

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or randi_range(mix, MAX) == MAX)

func tick(mark: Tick) -> int:
	if probable(_ost.theme.mix):
		#mark.actor.player.load_music(_ost.set.values().pick_random())
		var result = super.tick(mark)
		progress.emit(mark)
		return result
	return FAILED
