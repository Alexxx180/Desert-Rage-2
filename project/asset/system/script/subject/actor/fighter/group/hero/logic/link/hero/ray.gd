extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var unique: Node = $unique
@onready var fight: Node = $fight

func connect_tags(hero: CharacterBody2D, world: Node) -> void:
	var tags: TileMapLayer = hero.group.get_node("../tags")
	#if tags == null: return
	skills.controls(hero, world.skills, tags)
	ability.controls(hero, world.ability, tags.lockers.ability)

func controls(hero: CharacterBody2D, world: Node) -> void:
	hero.to.layers.hero = hero
	# connect_tags(hero, world) # TODO FIXME hero connect tags and skills
	unique.controls(hero)
	fight.controls(hero, world.fight)

func controls_stats(hero: CharacterBody2D, stats: Node) -> void:
	hero.logic.see.fight.hitbox.bash.connect(stats.health.hit)
	stats.health.aura.entity = hero
	stats.aura.bar = hero.view

	stats.health.points.setup(hero.logic.stats.health)
	stats.aura.setup(hero.logic.stats.aura)
