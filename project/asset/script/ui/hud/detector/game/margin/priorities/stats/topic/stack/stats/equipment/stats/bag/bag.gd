extends HBoxContainer

@onready var ray: Control = $ray
@onready var rock: Control = $rock

func select_hero(party: HeroParty) -> void:
	var leader: Control = get(party.leader.name)
	var follower: Control = get(party.follower.name)
	
	leader.back.hide()
	follower.back.show()
	remove_child(follower)
	add_child(follower)
