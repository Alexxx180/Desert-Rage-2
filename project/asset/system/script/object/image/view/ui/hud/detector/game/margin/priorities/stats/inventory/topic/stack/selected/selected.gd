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
	var follower: String = group.deploy.party.follower.name
	get(group.deploy.party.leader.name).show()
	get(follower).hide()
	# opened.bag = follower

func switch(hero: String) -> void:
	if opened.bag == hero:
		get(hero).visible = !get(hero).visible
	else:
		get(opened.bag).hide()
		get(hero).show()
	# opened.bag = hero
