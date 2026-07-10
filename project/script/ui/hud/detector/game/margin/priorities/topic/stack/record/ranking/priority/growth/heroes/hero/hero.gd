extends TextureRect

@onready var priority: VBoxContainer = $back/priority
@onready var stats: VBoxContainer = $back/stats

func change(prev: int, at: int) -> void:
	priority.priorities[prev].hide()
	# priority.priorities[at].show()



@onready var rank: Label = $rank
@onready var value: Label = $value

@onready var ray: TextureRect = $ray
@onready var rock: TextureRect = $rock

var selected: String = "ray"
var leader: TextureRect:
	get: return get(selected)

func select_hero(party: HeroParty) -> void:
	selected = party.leader.name
	get(selected).show()
	get(party.follower.name).hide()
