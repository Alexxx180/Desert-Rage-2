extends VBoxContainer

@onready var bag: HFlowContainer = $bag
@onready var stats: VBoxContainer = $stats
@onready var chats: VBoxContainer = $chats

func _ready() -> void:
	var group: Node2D = get_tree().current_scene.get_node("group")
	for hero in ["ray", "rock"]:
		bag.connect_group(hero, group)
		var ui: TextureButton = stats.stats.bag.get(hero)
		ui.connect_group(group)
		ui.switch_bags.connect(bag.switch)
		group.deploy.select_hero.connect(func(_h):
			bag.select_hero(group))
