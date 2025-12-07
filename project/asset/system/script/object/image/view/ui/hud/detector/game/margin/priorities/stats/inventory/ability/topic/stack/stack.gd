extends VBoxContainer

@onready var space: Control = $space
@onready var skill: VBoxContainer = $skill

func select_hero(party: HeroParty) -> void:
	space.status.preset.sets.skill.select_hero(party)
	skill.item.select_hero(party)
