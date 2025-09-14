extends Node

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	"""
	var priorities: HSplitContainer = 
	var stats: HSplitContainer = game.get_node("menu/stats")
	var inventory: HSplitContainer = game.get_node("menu/stats/inventory")
	var ability: HSplitContainer = game.get_node("menu/stats/inventory/ability")
	"""
	var status: HBoxContainer = game.controls.get_node("topic/items/status")
	var exp: VBoxContainer = status.get_node("experience")
	var score: Dictionary = {
		"bar": exp.get_node("meter/margin/next/score"),
		"count": exp.get_node("caption/main/space/margin/count")
	}
	var stats: VBoxContainer = game.stats.get_node("scroll/margin/stack/stats")
	
	group.xp.multiply.finish.connect(status.finish)
	group.xp.multiply.update_meter.connect(status.update_meter)
	group.xp.multiply.update_x.connect(status.update_multiplier)
	
	var tags: TileMapLayer = group.get_node("../tags")
	tags.enemy.hud.xp = group.xp
	group.xp.stats.update_stats.connect(stats.set_stats)
	for hero in ["ray", "rock"]:
		group.xp.stats.update_stats.connect(func(s):
			group.get_node(hero).view.animation.effect.set_stats(s[hero]))
	
	group.xp.update_priorities.connect(game.priorities.set_priorities)
	group.xp.update_exp.connect(game.priorities.update_exp)
	group.xp.update_exp.connect(func(value: Vector2i, base_xp: int):
		score.count.text = str(base_xp + value.x)
		score.bar.max_value = value.y
		score.bar.value = value.x)
	group.navigation = [game.get_node("menu/navigation"),
		game.get_node("menu/stats/navigation"),
		game.get_node("menu/stats/inventory/navigation"),
		game.get_node("menu/stats/inventory/ability/navigation")]
	for n in group.navigation:
		n.hud.resume_input.connect(group.resume_input)
		n.hud.suspend_input.connect(group.suspend_input)
	group.xp.sync()
