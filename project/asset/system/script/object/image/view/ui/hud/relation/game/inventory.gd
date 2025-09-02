extends Node

func controls(hud: CanvasLayer, inventory: VSplitContainer) -> void:
	var processor: Node = hud.processor.game.inventory
	processor.inventory.append(inventory.get_node("topic/scroll/margin/flow/items"))
	processor.inventory.append(hud.detector.game.get_node("menu/stats/topic/scroll/margin/stack/items/ray"))
	processor.markers = hud.detector.game.markers
	# processor.markers = inventory.get_node("ability/controls/markers")
	# """
	for hero in hud.get_node("../../group").deploy.party.heroes:
		var ui: Node = hero.logic.processors.ui.inventory.logic
		ui.items.inventory = hud.detector.game.inventory.items
		ui.update_inventory_storage()
		for i in range(0, len(ui.items.inventory.items)):
		# for button in ui.items.inventory.items:
			ui.items.inventory.items[i].pressed.connect(func():
				ui.effect.use_item(i, ui.storage[i]))
	# """
