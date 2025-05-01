extends BehaviorActionPlayback

class_name HeroBattleTheme

signal progress(mark: Tick)

enum { MIN = 0, MAX = 100 }

func set_ost(music: Node) -> void:
	_ost = music.world.named.ost.rampage

func _compare(mix: int) -> bool:
	var value: int = randi_range(MIN, MAX)
	return MIN <= value and value < mix

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or _compare(mix))

func tick(mark: Tick) -> int:
	if probable(_ost.theme.mix):
		#mark.actor.player.load_music(_ost.set.values().pick_random())
		#var result = super.tick(mark)
		#progress.emit(mark)
		var hero: String = ["ray", "rock"].pick_random()
		mark.actor.as_blend(_ost, _ost.ui.set[hero])
		progress.emit(mark)
		return OK
	return FAILED
