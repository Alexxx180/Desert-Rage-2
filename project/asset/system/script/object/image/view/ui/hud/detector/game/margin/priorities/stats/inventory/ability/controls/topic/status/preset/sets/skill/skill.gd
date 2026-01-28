extends MarginContainer

@onready var sets: HBoxContainer = $options/sets
@onready var analyze: Button = $options/analyze

func select_hero(party: HeroParty) -> void:
	sets.get(party.leader.name).show()
	sets.get(party.follower.name).hide()
