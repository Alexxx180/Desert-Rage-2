extends Node

var hero: CharacterBody2D
var ability: Node

func setup(h: CharacterBody2D, a: Node) -> void:
	hero = h ; ability = a

func fire_ice(body: CharacterBody2D) -> void:
	ability.fire.near_map(body, hero)

func fire_far_ice(body: CharacterBody2D) -> void:
	ability.fire.far_map(body, hero)

func fire_torch(body: CharacterBody2D) -> void:
	ability.fire.near_box(body, hero)

func fire_far_torch(body: CharacterBody2D) -> void:
	ability.fire.far_box(body, hero)

func fire_enemy(body: CharacterBody2D) -> void:
	ability.fire.near_box(body, hero)

func fire_far_enemy(body: CharacterBody2D) -> void:
	ability.fire.far_box(body, hero)
