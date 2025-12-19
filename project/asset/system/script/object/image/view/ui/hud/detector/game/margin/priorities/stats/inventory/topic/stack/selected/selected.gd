extends HFlowContainer

@onready var ray: MarginContainer = $ray
@onready var rock: MarginContainer = $rock
@onready var selection: Array[Dictionary] = [get_cursor(), get_cursor()]

var opened: Node

func hides() -> void: get(opened.bag).items.hide()
func shows() -> void: get(opened.bag).items.show()

func connect_group(hero: String, group: Node2D, _opened: Node) -> void:
	var ui: HFlowContainer = get(hero).items
	ui.set_items(hero, group)
	ui.connect_selection(selection)
	opened = _opened

func get_cursor() -> Dictionary:
	return { "bag": Defaults.NODE, "slot": Defaults.INT }

func select_hero(group: Node) -> void:
	var leader: String = group.deploy.party.leader.name
	var follower: String = group.deploy.party.follower.name
	get(leader).show()
	var ui: MarginContainer = get(follower)
	ui.visible = opened.other
	remove_child(ui)
	add_child(ui)

func switch(hero: String) -> void:
	#get(hero).visible = !get(hero).visible
	#"""
	if opened.bag == hero: #pass
		get(hero).visible = !get(hero).visible
	else:
		get(opened.bag).hide()
		get(hero).show()
	#"""
