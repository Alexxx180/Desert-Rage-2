extends HFlowContainer

var _ray: HFlowContainer = null
var ray: HFlowContainer:
	get: upload_bag(_ray, "ray") ; return _ray

var _rock: HFlowContainer = null
var rock: HFlowContainer:
	get: upload_bag(_rock, "rock") ; return _rock

func upload_bag(hero: HFlowContainer, title: String) -> void:
	if hero == null:
		hero = PreloadBus.bag.instantiate() # set("_" + title, hero) if ref won't work
		hero.name = title
		var space: Control = get_node(title)
		space.add_sibling(hero)
		remove_child(space)

var opened: Node

func hides() -> void: get(opened.bag).hide()
func shows() -> void: get(opened.bag).show()

func connect_group(hero: String, group: Node2D, _opened: Node) -> void:
	var ui: HFlowContainer = get(hero).items
	group.get(hero).to.inventory.logic.trade.ui.set_items(ui)
	opened = _opened

func select_hero(group: Node) -> void:
	var leader: String = group.deploy.party.leader.name
	var follower: String = group.deploy.party.follower.name
	get(leader).show()
	var ui: MarginContainer = get(follower)
	ui.visible = opened.other
	remove_child(ui)
	add_child(ui)

func switch(hero: String) -> void:
	if opened.bag == hero:
		get(hero).visible = !get(hero).visible
	else:
		get(opened.bag).hide()
		get(hero).show()
