extends VBoxContainer

@onready var ray: HBoxContainer = $ray
@onready var rock: HBoxContainer = $rock

func select_hero(party: HeroParty) -> void:
	get(party.follower.name).hide()
	get(party.leader.name).show()
