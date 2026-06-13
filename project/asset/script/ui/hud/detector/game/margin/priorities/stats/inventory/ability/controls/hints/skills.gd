extends GridContainer

var hero_name: String = "ray"

@onready var skills: Dictionary = {
	"ray": {
		"head": $margin/ray,
		"slap": $margin/ray/left/weapon/knuckles/slap
	},
	"rock": {
		"head": $margin/rock,
		"slap": $margin/rock/left/weapon/knuckles/slap
	},
}

func init_focus() -> void:
	skills[hero_name].slap.grab_focus()

func select_hero(hero: CharacterBody2D) -> void:
	skills[hero_name].head.hide()
	hero_name = hero.name
	skills[hero_name].head.show()
