extends Node

var _stats: Dictionary = Defaults.DICT

func _get_xp_score(exp: VBoxContainer) -> Dictionary:
	return {
		"bar": exp.get_node("meter/margin/next/space/score"),
		"count": exp.get_node("caption/main/space/margin/count")
	}

func _bind_enemy_xp(group: Node2D) -> void:
	group.lay.tags.layer.enemy.hud.xp = group.xp

func _set_stats(group: Node2D, game: Control) -> void:
	var stats: VBoxContainer = game.priorities.stats.topic.stack.stats
	var priority: VBoxContainer = game.priorities.topic.stack.record
	var party: HeroParty = group.deploy.party
	group.xp.update_priorities.connect(func(_level, s):
		_stats = s
		stats.set_stats(s, party.leader.name)
		for hero in ["ray", "rock"]:
			group.get(hero).view.animation.effect.set_stats(s.stats[hero])
		priority.set_priorities(_level, _stats, group)
	)
	group.deploy.select_hero.connect(func(leader):
		if _stats == Defaults.DICT:
			_stats = group.xp.current_stats()

		stats.stats.bag.select_hero(party)
		stats.set_stats(_stats, party.leader.name)

		game.controls.topic.status.preset.sets.skill.select_hero(party)
		game.priorities.stats.inventory.ability.topic.stack.select_hero(party)
		group.get(leader.name).view.animation.effect.set_stats(_stats.stats[leader.name]) # get(leader.name)
	)

func _set_multiply(multiply: Node, status: BoxContainer) -> void:
	multiply.finish.connect(status.finish)
	multiply.update_meter.connect(status.update_meter)
	multiply.update_x.connect(status.update_multiplier)

func _set_priorities(group: Node2D, topic: PanelContainer, status: HBoxContainer) -> void:
	var priority: VBoxContainer = topic.stack.record#.priority
	# group.xp.update_priorities.connect(priority.set_priorities) # var score: Dictionary = _get_xp_score(status.get_node("experience/xp"))
	priority.connect_priority_select(group.xp.level, group)
	group.xp.update_exp.connect(priority.update_exp)

func _set_navigation(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	group.navigation = hud.relation.game.ability.navigation
	for n in group.navigation:
		n.hud.resume_input.connect(group.resume_input)
		n.hud.suspend_input.connect(group.suspend_input)

func _status(topic: Control) -> HBoxContainer:
	return topic.status.space.title.status

func _set_advanced_xp(group: Node2D, game: Control) -> void:
	var topic: PanelContainer = game.priorities.stats.inventory.ability.topic
	var status: HBoxContainer = _status(topic.stack.space)
	var logs: PanelContainer = game.controls.preview.chats.log #var long: VBoxContainer = game.ability.get_node("scroll/margin/stack/ability/score") # var short: VBoxContainer = game.ability.get_node("scroll/margin/stack/menu/space/fast_access/status/experience/xp")
	for xp in [_status(game.controls.topic), status]:
		_set_multiply(group.xp.level.multiply, xp) # var score: Dictionary = _get_xp_score(status.get_node("experience"))
		xp.set_xp_score(group.xp)
	group.xp.update_priorities.connect(logs.set_priority)
	_set_priorities(group, game.priorities.topic, status)

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	_bind_enemy_xp(group)
	_set_stats(group, game)
	_set_advanced_xp(group, game)
	_set_navigation(hud, group, game)
	group.xp.sync()
