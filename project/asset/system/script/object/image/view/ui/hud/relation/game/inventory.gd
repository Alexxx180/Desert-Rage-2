extends Node

func controls(hud: CanvasLayer, inventory: VSplitContainer) -> void:
	var processor: Node = hud.processor.game.inventory
	processor.inventory.append(inventory.get_node("topic/scroll/margin/flow/items"))
	processor.inventory.append(hud.detector.game.get_node("menu/stats/topic/scroll/margin/stack/items"))
	processor.markers = hud.detector.game.get_node("margin/markers")
	# processor.markers = inventory.get_node("ability/controls/markers")
	# """
	for hero in hud.get_node("../../group").deploy.party.heroes:
		var ui: Node = hero.logic.processors.ui
		ui.inventory.logic.inventory = hud.detector.game.inventory.items
		ui.inventory.logic.update_inventory_storage()
	# """
