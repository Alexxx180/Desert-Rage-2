extends BehaviorActionPlayback

class_name HeroBattleTheme

enum { MIN = 0, MAX = 100, RAMPAGE = 1 }

func get_context(options: Node, progress: Dictionary) -> Dictionary:
	progress.rampage = HeroBattleTheme.RAMPAGE
	return {
		"ost": SoundtrackSystem.user.world.rampage.name,
		"ui": options.ui.world.rampage.name.set
	}

func set_actions(options: Node, context: Dictionary) -> void:
	options.set_named_theme(context.duplicate())

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or randi_range(mix, MAX) == MAX)

func tick(mark: Tick) -> int:
	if probable(_context.mix):
		mark.actor.player.load_music(_context.set.ray)
		mark.blackboard.set_value("rampage", RAMPAGE + 1)
		return OK
	return FAILED
