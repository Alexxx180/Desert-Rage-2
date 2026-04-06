extends Node

@onready var skills: Node = $skills
@onready var ability: Node = $ability
@onready var around: Node = $around # @onready var fight: Node = $fight

func controls(hero: CharacterBody2D, world: Node) -> void:
	hero.to.layers.hero = hero
	# connect_tags(hero, world) # TODO FIXME hero connect tags and skills
	around.controls(hero)
	# fight.controls(hero, world.fight) # TODO FIXME fight

func connect_tags(hero: CharacterBody2D, world: Node) -> void:
	#if tags == null: return
	skills.controls(hero, world.skills, hero.group.root.tags)
	ability.controls(hero, world.ability, hero.group.work.lockers.ability)

func controls_stats(hero: CharacterBody2D, stats: Node) -> void:
	hero.logic.see.fight.hitbox.bash.connect(stats.health.hit)
	stats.health.aura.entity = hero
	stats.aura.bar = hero.view

	stats.health.points.setup(hero.logic.stats.health)
	stats.aura.setup(hero.logic.stats.aura)
