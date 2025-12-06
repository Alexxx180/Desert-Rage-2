extends Node

func _set_stamina(hero: CharacterBody2D, game: Control) -> void:
	var f_stamina: ProgressBar = game.priorities.stats.topic.stamina.amount
	var stamina: Control = game.controls.preview.chats.stamina
	var bar: ProgressBar = stamina.amount
	var run: Node = hero.to.act.run.state
	run.hero = hero
	run.new_mach.connect(func(next: int):
		f_stamina.value = next
		bar.value = next; if run.is_delayed(next): stamina.show())
	run.stop_mach.connect(func(): stamina.hide())

func _set_ability(stats: Node, ap: ProgressBar) -> void:
	# var amount: ProgressBar = ui.get_node("health/hp/margin/health/aura")
	stats.aura.update_bar.connect(func(v): ap.value = v)

func _set_health(stats: Node, hp: HBoxContainer, hero: String) -> void:
	# var amount: ProgressBar = ui.get_node("health/hp/margin/health/amount")
	stats.health.points.update_bar.connect(func(_v):
		hp.change(hero, stats.health.points))

func _set_stats(hero: CharacterBody2D, game: Control) -> void:
	var stats: Node = hero.logic.work.stats
	_set_health(stats, game.controls.status.sticker.hp, hero.name)
	_set_ability(stats, game.controls.topic.status.preset.sets.ap.cost)

func _set_hero(hero: CharacterBody2D, game: Control) -> void:
	_set_stats(hero, game)
	_set_stamina(hero, game)

func controls(group: Node2D, game: Control) -> void:
	for hero in ["ray", "rock"]: _set_hero(group.get(hero), game)
