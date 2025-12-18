extends VBoxContainer

@onready var bag: HFlowContainer = $bag# $items/bag
@onready var status: HFlowContainer = $points/status
@onready var sticker: MarginContainer = $sticker

func connect_group(group: Node2D, opened: Node) -> void:
	pass
	# var group: Node2D = get_tree().current_scene.get_node("group")
	"""
	for hero in ["ray", "rock"]:
		bag.connect_group(hero, group, opened)
		var ui: HFlowContainer = status.get(hero)
		ui.set_inventory(group)
		# ui.bag.switch_bags.connect(bag.switch)
		group.deploy.select_hero.connect(func(_h):
			bag.select_hero(group))
	"""
