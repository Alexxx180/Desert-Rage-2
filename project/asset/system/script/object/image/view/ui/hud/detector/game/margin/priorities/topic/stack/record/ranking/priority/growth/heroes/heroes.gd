extends HBoxContainer

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

var selected: String = "ray"
var leader: TextureRect:
	get: return get(selected)

func select_hero(party: HeroParty) -> void:
	selected = party.leader.name
	get(selected).show()
	get(party.follower.name).hide()
