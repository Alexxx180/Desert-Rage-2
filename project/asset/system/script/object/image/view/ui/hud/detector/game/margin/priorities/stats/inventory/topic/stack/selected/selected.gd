extends HFlowContainer

@onready var ray: MarginContainer = $ray
@onready var rock: MarginContainer = $rock

var opened: Node

func hides() -> void: get(opened.bag).items.hide()
func shows() -> void: get(opened.bag).items.show()

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
