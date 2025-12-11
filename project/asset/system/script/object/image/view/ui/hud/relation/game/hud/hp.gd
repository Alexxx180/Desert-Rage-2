extends Node

func _set_stamina(hero: CharacterBody2D, game: Control) -> void:
	var f_stamina: ProgressBar = game.priorities.stats.topic.stamina.amount
	var stamina: Control = game.controls.preview.chats.stamina
	var bar: ProgressBar = stamina.amount
	var run: Node = hero.to.act.run.state
	run.hero = hero
	run.atb.show.connect(hero.view.barrier.set_atb)
	"""
	run.new_mach.connect(func(next: int):
		f_stamina.value = next
		bar.value = next; if run.is_delayed(next): stamina.show())
	"""
	run.stop_mach.connect(func(): stamina.hide())

func _set_ability(stats: Node, game: Control, hero: CharacterBody2D) -> void:
	for sets in [game.controls.topic.status.preset.sets,
		game.priorities.stats.inventory.ability.topic.stack.space.status.preset.sets]:
		stats.aura.update_bar.connect(func(_v):
			sets.use_skill(stats.aura))
	stats.aura.update_bar.connect(func(v):
		game.priorities.set_points("ability", hero.name, v))

func _set_health(stats: Node, game: Control, hero: CharacterBody2D) -> void:
	stats.health.points.update_bar.connect(func(v):
		game.controls.status.sticker.hp.change(hero.name, stats.health.points)
		game.priorities.set_points("health", hero.name, v)
	)

func _set_stats(hero: CharacterBody2D, game: Control) -> void:
	for points in [_set_health, _set_ability]:
		points.call(hero.logic.work.stats, game, hero)

func _set_hero(hero: CharacterBody2D, game: Control) -> void:
	for attribute in [_set_stats, _set_stamina]: attribute.call(hero, game)

func controls(group: Node2D, game: Control) -> void:
	for hero in ["ray", "rock"]: _set_hero(group.get(hero), game)

	group.deploy.select_hero.connect(func(_l):
		game.controls.status.sticker.hp.select(group.deploy.party)
	)
