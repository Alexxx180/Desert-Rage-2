extends HBoxContainer

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

func select_hero(party: HeroParty) -> void:
	var leader: TextureRect = get(party.leader.name)
	var follower: TextureRect = get(party.follower.name)
	
	leader.back.hide()
	follower.back.show()
	remove_child(follower)
	add_child(follower)
