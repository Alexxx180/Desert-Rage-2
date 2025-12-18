extends HFlowContainer

@onready var ray: MarginContainer = $ray
@onready var rock: MarginContainer = $rock
@onready var selection: Array[Dictionary] = [get_cursor(), get_cursor()]

var opened_bag: String = "rock"

func connect_group(hero: String, group: Node2D) -> void:
	var ui: HFlowContainer = get(hero).items
	ui.set_items(hero, group)
	ui.connect_selection(selection)

func get_cursor() -> Dictionary:
	return { "bag": Defaults.NODE, "slot": Defaults.INT }

func select_hero(group: Node) -> void:
	var follower: String = group.deploy.party.follower.name
	get(group.deploy.party.leader.name).show()
	get(follower).hide()
	opened_bag = follower

func switch(hero: String) -> void:
	if opened_bag == hero:
		get(hero).visible = !get(hero).visible
	else:
		get(opened_bag).hide()
		get(hero).show()
	opened_bag = hero
