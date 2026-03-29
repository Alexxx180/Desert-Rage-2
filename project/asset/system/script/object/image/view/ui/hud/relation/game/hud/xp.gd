extends Node

var _stats: Dictionary = Defaults.DICT
var stats: VBoxContainer = null
var priority: VBoxContainer = null
var group: Node2D
var game: Control
var logs: PanelContainer

func _get_xp_score(exp: VBoxContainer) -> Dictionary:
	return {
		"bar": exp.get_node("meter/margin/next/space/score"),
		"count": exp.get_node("caption/main/space/margin/count")
	}

func connect_xp() -> void:
	if stats == null or priority == null: return
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

		# game.controls.topic.status.preset.sets.skill.select_hero(party) # TODO FIXME SELECT
		game.priorities.stats.inventory.ability.topic.stack.select_hero(party)
		group.get(leader.name).view.animation.effect.set_stats(_stats.stats[leader.name]) # get(leader.name)
	)
	priority.connect_priority_select(group.xp.level, group)
	group.xp.update_exp.connect(priority.update_exp)

func connect_stats(stack: Container) -> void:
	stats = stack.stats
	connect_xp()

func connect_priority(stack: Container) -> void:
	priority = stack.record
	connect_xp()

func _set_stats(g: Node2D, m: Control) -> void:
	group = g ; game = m ; var stats = game.priorities.stats
	stats.topic.loaded.connect(connect_stats)
	game.priorities.topic.loaded.connect(connect_priority)
	stats.inventory.ability.topic.loaded.connect(set_ability)
	logs = game.controls.hints.space.preview.chats.list.logs

func _set_multiply(multiply: Node, status: BoxContainer) -> void:
	multiply.finish.connect(status.finish)
	multiply.update_meter.connect(status.update_meter)
	multiply.update_x.connect(status.update_multiplier)

func _set_priorities(group: Node2D, topic: PanelContainer, status: HBoxContainer) -> void:
	pass # var priority: VBoxContainer = topic.stack.record#.priority
	# group.xp.update_priorities.connect(priority.set_priorities) # var score: Dictionary = _get_xp_score(status.get_node("experience/xp"))
	# priority.connect_priority_select(group.xp.level, group)
	# group.xp.update_exp.connect(priority.update_exp)

func _set_navigation(hud: CanvasLayer) -> void:
	group.navigation = hud.relation.game.menu.navigation
	for n in group.navigation:  # .space.title # status
		n.hud.resume_input.connect(group.resume_input)
		n.hud.suspend_input.connect(group.suspend_input)

func set_xp_multiply(xp) -> void:
	_set_multiply(group.xp.level.multiply, xp) # var score: Dictionary = _get_xp_score(status.get_node("experience"))
	xp.set_xp_score(group.xp)

func set_ability(stack: Container) -> void:
	set_xp_multiply(stack.space.status)
	set_xp_multiply(game.controls.topic.status)
	if group.lay != null:
		group.lay.tags.layer.enemy.hud.xp = group.xp
	group.xp.update_priorities.connect(logs.set_priority)

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	_set_stats(group, game) # _bind_enemy_xp()
	_set_navigation(hud)
	# _set_priorities(group, game.priorities.topic, status)
	group.xp.sync()
