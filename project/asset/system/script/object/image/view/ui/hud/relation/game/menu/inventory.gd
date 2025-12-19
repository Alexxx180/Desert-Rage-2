extends Node

var bag: String = "rock"
var other: bool = false

func update_inventory(ui: Node) -> void:
	ui.update_inventory_storage() # TODO UPDATE INVENTORY
	for i in range(0, len(ui.items.inventory.items)): # for button in ui.items.inventory.items:
		ui.items.inventory.items[i].pressed.connect(func():
			ui.effect.use_item(i, ui.storage[i]))

func controls(hud: CanvasLayer, group: Node2D, inventory: VSplitContainer) -> void:
	var processor: Node = hud.processor.game.inventory
	var stack: Container = inventory.topic.stack
	var topic: PanelContainer = hud.detector.game.priorities.stats.topic
	processor.inventory.append(stack.bag.ray.items)
	processor.inventory.append(topic.stack.bag.ray.items)
	processor.markers = hud.detector.game.controls.status.markers
	
	# TODOT invcon
	# hud.detector.game.priorities.stats.inventory

	var status: VBoxContainer = hud.detector.game.priorities.topic.stack.status
	group.deploy.select_hero.connect(func(_h): status.select_hero(group))
	# stack.connect_group(group, self)
	topic.stack.connect_group(stack, status, group, self)
	
	# processor.markers = inventory.get_node("ability/controls/markers")
	for hero in group.deploy.party.heroes:
		hero.to.inventory.logic.items.ui.inventory = [
			stack.bag.get(hero.name).items, topic.stack.bag.get(hero.name).items
		] # TODO FIXME set processor inventory instead
		# update_inventory(ui)
