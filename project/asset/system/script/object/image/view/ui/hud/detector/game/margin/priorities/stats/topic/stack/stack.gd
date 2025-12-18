extends VBoxContainer

@onready var bag: HFlowContainer = $bag
@onready var stats: VBoxContainer = $stats
@onready var chats: VBoxContainer = $chats

func connect_bag(ui: Array, inventory: HFlowContainer, opened: Node) -> void:
	for change in ui:
		for b in [bag, inventory]:
			change.switch_bags.connect(b.switch)
		change.switch_bags.connect(func(h): opened.bag = h)

func connect_group(stack: VBoxContainer, group: Node2D, opened: Node) -> void:
	for hero in ["ray", "rock"]:
		for bg in [bag, stack.bag]: bg.connect_group(hero, group, opened)
		var b: Button = stack.status.get(hero).bag
		var ui: TextureButton = stats.stats.bag.get(hero)
		var res: Array = [ui, b]
		for i in res: i.set_inventory(group)
		connect_bag(res, stack.bag, opened)
	group.deploy.select_hero.connect(func(_h):
		bag.select_hero(group)
		stack.bag.select_hero(group)
		opened.bag = group.deploy.party.follower.name)
