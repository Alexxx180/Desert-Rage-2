extends VBoxContainer

@onready var space: Control = $space
@onready var perks: VBoxContainer = $perks
@onready var item: VBoxContainer = $item

func select_hero(party: HeroParty) -> void:
	space.status.preset.sets.skill.select_hero(party)
	item.select_hero(party)
