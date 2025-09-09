extends Node

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	"""
	var priorities: HSplitContainer = 
	var stats: HSplitContainer = game.get_node("menu/stats")
	var inventory: HSplitContainer = game.get_node("menu/stats/inventory")
	var ability: HSplitContainer = game.get_node("menu/stats/inventory/ability")
	"""
	group.navigation = [game.get_node("menu/navigation"),
		game.get_node("menu/stats/navigation"),
		game.get_node("menu/stats/inventory/navigation"),
		game.get_node("menu/stats/inventory/ability/navigation")]
	for n in group.navigation:
		n.hud.resume_input.connect(group.resume_input)
		n.hud.suspend_input.connect(group.suspend_input)
