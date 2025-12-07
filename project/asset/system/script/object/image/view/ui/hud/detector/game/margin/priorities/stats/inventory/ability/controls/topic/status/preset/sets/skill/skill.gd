extends MarginContainer

@onready var sets: HBoxContainer = $options/sets

func select_hero(party: HeroParty) -> void:
	sets.get(party.leader.name).show()
	sets.get(party.follower.name).hide()
