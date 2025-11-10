extends Node

func _get_xp_score(exp: VBoxContainer) -> Dictionary:
	return {
		"bar": exp.get_node("meter/margin/next/space/score"),
		"count": exp.get_node("caption/main/space/margin/count")
	}

func _get_navigation(game: Control) -> Array:
	return [game.get_node("menu/navigation"),
		game.get_node("menu/stats/navigation"),
		game.get_node("menu/stats/inventory/navigation"),
		game.get_node("menu/stats/inventory/ability/navigation")]

func _bind_enemy_xp(group: Node2D) -> void:
	group.lay.tags.layer.enemy.hud.xp = group.xp

func _set_stats(group: Node2D, game: Control) -> void:
	var stats: VBoxContainer = game.stats.get_node("scroll/margin/stack/stats")
	group.xp.stats.update_stats.connect(stats.set_stats)
	var meter: ProgressBar# scroll/margin/stack/ability/score/exp/total/combo/meter
	for hero in ["ray", "rock"]:
		group.xp.stats.update_stats.connect(func(s):
			group.get(hero).view.animation.effect.set_stats(s[hero]))

func _set_multiply(multiply: Node, status: BoxContainer) -> void:
	multiply.finish.connect(status.finish)
	multiply.update_meter.connect(status.update_meter)
	multiply.update_x.connect(status.update_multiplier)

func _set_priorities(xp: Node, priorities: PanelContainer, status: HBoxContainer) -> void:
	var score: Dictionary = _get_xp_score(status.get_node("experience/xp"))
	xp.update_priorities.connect(priorities.set_priorities)
	priorities.connect_priority_select(xp.summary)
	xp.update_exp.connect(priorities.update_exp)

func _set_navigation(group: Node2D, game: Control) -> void:
	group.navigation = _get_navigation(game)
	for n in group.navigation:
		n.hud.resume_input.connect(group.resume_input)
		n.hud.suspend_input.connect(group.suspend_input)

func _set_advanced_xp(group: Node2D, game: Control) -> void:
	var status: HBoxContainer = game.controls.get_node("topic/items/ability/status")
	var fast_access: HBoxContainer = game.ability.get_node("scroll/margin/stack/menu/space/fast_access/status")
	#var long: VBoxContainer = game.ability.get_node("scroll/margin/stack/ability/score")
	
	# var short: VBoxContainer = game.ability.get_node("scroll/margin/stack/menu/space/fast_access/status/experience/xp")
	for xp in [status, fast_access]:
		_set_multiply(group.xp.multiply, xp)
		# var score: Dictionary = _get_xp_score(status.get_node("experience"))
		xp.set_xp_score(group.xp)
	_set_priorities(group.xp, game.priorities, status)

func controls(group: Node2D, game: Control) -> void:
	_bind_enemy_xp(group)
	_set_stats(group, game)
	_set_advanced_xp(group, game)
	_set_navigation(group, game)
	group.xp.sync()
