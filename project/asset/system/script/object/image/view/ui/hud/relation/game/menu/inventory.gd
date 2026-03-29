extends Node

var bag: String = "rock"
var other: bool = false
var hud: CanvasLayer
var group: Node2D

func update_inventory(ui: Node) -> void:
	ui.update_inventory_storage() # TODO UPDATE INVENTORY
	for i in range(0, len(ui.items.inventory.items)): # for button in ui.items.inventory.items:
		ui.items.inventory.items[i].pressed.connect(func():
			ui.effect.use_item(i, ui.storage[i]))

func connect_inventory(stack: Container) -> void:
	var processor: Node = hud.processor.game.inventory
	var topic: PanelContainer = hud.see.game.priorities.stats.topic
	processor.inventory.append(stack.bag.ray.items)
	processor.inventory.append(topic.stack.bag.ray.items)
	processor.markers = hud.see.game.controls.status.markers
	
	var status: VBoxContainer = hud.see.game.priorities.topic.stack.status
	group.deploy.select_hero.connect(func(_h): status.select_hero(group))
	topic.stack.connect_group(stack, status, group, self)
	
	for hero in group.deploy.party.heroes:
		#hero.to.inventory.logic.items.ui.inventory = [
		#	stack.bag.get(hero.name).items, topic.stack.bag.get(hero.name).items]
		for i in [stack.status.get(hero.name),
			 hud.see.game.priorities.topic.stack.status.get(hero.name)]:
			i.ability.set_inventory(hero)
			i.health.set_inventory(hero)

func controls(h: CanvasLayer, g: Node2D, inventory: VSplitContainer) -> void:
	hud = h; group = g
	inventory.topic.loaded.connect(connect_inventory)
	# TODOT invcon # hud.detector.game.priorities.stats.inventory # stack.connect_group(group, self)
	# processor.markers = inventory.get_node("ability/controls/markers")
