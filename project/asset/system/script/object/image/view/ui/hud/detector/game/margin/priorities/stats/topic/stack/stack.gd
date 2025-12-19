extends VBoxContainer

@onready var bag: HFlowContainer = $bag
@onready var stats: VBoxContainer = $stats
@onready var chats: VBoxContainer = $chats

func connect_bag(ui: Array, inventory: HFlowContainer, opened: Node) -> void:
	for change in ui:
		for b in [bag, inventory]:
			change.switch_bags.connect(b.switch)
		change.switch_bags.connect(func(h):
			opened.bag = h
			opened.other = !opened.other)

func toggle_buttons(stack: VBoxContainer, status: VBoxContainer, leader: String, opened: Node, feedback: Callable) -> Array:
	var b: Button = stack.status.get(leader).bag
	var b2: Button = status.get(leader).bag
	var ui: TextureButton = stats.stats.bag.get(leader)
	var res: Array = [ui, b, b2]
	for i in res: feedback.call(i)
	return res

func _toggle_order(stack: VBoxContainer, status: VBoxContainer, party: HeroParty, opened: Node) -> void:
	for i in [[party.leader.name, func(i): i.disabled = true], [party.follower.name, func(i): i.disabled = false]]:
		toggle_buttons(stack, status, i[0], opened, i[1])

func connect_group(stack: VBoxContainer, status: VBoxContainer, group: Node2D, opened: Node) -> void:
	stack.connect_group(group)
	for hero in ["ray", "rock"]:
		for bg in [bag, stack.bag]: bg.connect_group(hero, group, opened)
		var res = toggle_buttons(stack, status, hero, opened, func(i): i.set_inventory(group))
		connect_bag(res, stack.bag, opened)
	group.deploy.select_hero.connect(func(_h):
		bag.select_hero(group)
		stack.bag.select_hero(group)
		opened.bag = group.deploy.party.follower.name
		
		_toggle_order(stack, status, group.deploy.party, opened)
	)
	_toggle_order(stack, status, group.deploy.party, opened)
