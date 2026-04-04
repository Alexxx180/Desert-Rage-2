extends Node

var ranged: FightRangeHeader = FightRangeHeader.new()
# @onready var music: Node = $music

func controls(hero: CharacterBody2D, fight: Node) -> void: # music.controls(hero)
	fight.group = hero.group # fight.movement.hero = hero
	hero.to.effect.close_damage.connect(fight.close.hit)
	ranged.setup(hero, fight)
	connect_lever(hero.logic.see.fight.after_tile)
	connect_book(hero.logic.see.fight.sided)
	connect_zones(hero)

func connect_lever(lever: Area2D) -> void:
	lever.body_entered.connect(ranged.enter_lever)
	lever.body_exited.connect(ranged.exit_lever)

func connect_book(book: Area2D) -> void:
	book.body_entered.connect(ranged.enter_book)
	book.body_exited.connect(ranged.exit_book)

func connect_zones(hero: CharacterBody2D) -> void:
	for area in ["close", "zone"]: ranged.set_zone(hero.logic.see.fight, area)
