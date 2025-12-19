extends Container

@onready var ray: HFlowContainer = $ray
@onready var rock: HFlowContainer = $rock

func select_hero(group: Node2D) -> void:
	get(group.deploy.party.leader.name).bag.hide()
	var follower: String = group.deploy.party.follower.name
	var ui: HFlowContainer = get(follower)
	ui.bag.show()
	remove_child(ui)
	add_child(ui)
