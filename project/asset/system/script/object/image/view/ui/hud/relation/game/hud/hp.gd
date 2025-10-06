extends Node

func _set_stamina(hero: CharacterBody2D, ui: HBoxContainer) -> void:
	var stamina: Control = ui.get_node("health/hp/margin/health/stamina")
	var bar: ProgressBar = stamina.get_node("amount")
	var run: Node = hero.logic.work.input.topdown.move.act.run.state
	run.hero = hero
	run.new_mach.connect(func(next: int):
		bar.value = next; if run.is_delayed(next): stamina.show())
	run.stop_mach.connect(func(): stamina.hide())

func _set_ability(stats: Node, ui: HBoxContainer) -> void:
	var amount: ProgressBar = ui.get_node("ap/margin/combo/aura")
	stats.aura.update_bar.connect(func(v): amount.value = v)

func _set_health(stats: Node, ui: HBoxContainer) -> void:
	var amount: ProgressBar = ui.get_node("health/hp/margin/health/amount")
	stats.health.points.update_bar.connect(func(v): amount.value = v)

func _set_stats(hero: CharacterBody2D, ui: HBoxContainer) -> void:
	var stats: Node = hero.logic.work.stats
	_set_health(stats, ui)
	_set_ability(stats, ui)

func _set_hero(hero: CharacterBody2D, markers: HFlowContainer) -> void:
	var ui: HBoxContainer = markers.get_node("margin/score/stack/" + hero.name)
	_set_stats(hero, ui)
	_set_stamina(hero, ui)

func controls(group: Node2D, game: Control) -> void:
	for hero in ["ray", "rock"]:
		_set_hero(group.get(hero), game.markers)
