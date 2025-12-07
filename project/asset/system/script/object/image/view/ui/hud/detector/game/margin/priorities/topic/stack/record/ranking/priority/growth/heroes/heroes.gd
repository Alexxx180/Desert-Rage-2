extends HBoxContainer

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

func select_hero(party: HeroParty) -> void:
	get(party.leader.name).show()
	get(party.follower.name).hide()
