extends Node

var _detector: Area2D
var _hero: CharacterBody2D
var ranged: FightRangeHeader = FightRangeHeader.new()
# @onready var music: Node = $music
var tiles: TilesBelt = TilesBelt.new(2, 3).add("COMFORTER").add("ADJUSTER")

func determine_static(execute: TileMapLayer) -> void:
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	match tile.atlas:
		tiles.AS.COMFORTER: execute.recovery.recover(_hero, "hp")
		tiles.AS.ADJUSTER: execute.recovery.recover(_hero, "ap")

func distract(execute: TileMapLayer) -> void:
	pass # execute.recovery.stop_recover(_hero, category)
	# if category != "": category = ""

func controls_unique() -> void:
	_detector = _hero.logic.see.world.unique
	_detector.body_entered.connect(determine_static)
	_detector.body_exited.connect(distract)

func controls(hero: CharacterBody2D, fight: Node) -> void: # music.controls(hero)
	_hero = hero
	controls_fight(fight)

func controls_fight(fight: Node) -> void:
	fight.group = _hero.group # fight.movement.hero = hero
	_hero.to.effect.close_damage.connect(fight.close.hit)
	ranged.setup(_hero, fight)
	controls_unique()
	connect_lever(_hero.logic.see.fight.after_tile)
	connect_book(_hero.logic.see.fight.sided)
	connect_zones(_hero.logic.see.fight)
	controls_inventory(_hero.to.inventory)

func connect_lever(lever: Area2D) -> void:
	lever.body_entered.connect(ranged.enter_lever)
	lever.body_exited.connect(ranged.exit_lever)

func connect_book(book: Area2D) -> void:
	book.body_entered.connect(ranged.enter_book)
	book.body_exited.connect(ranged.exit_book)

func connect_zones(fight: Node2D) -> void:
	for area in ["close", "zone"]: ranged.set_zone(fight, area)

func controls_inventory(inventory: Node) -> void:
	var chest: Area2D = _hero.to.skills.chest
	var level: Node2D = _hero.get_node("../..")

	var chests: Node = level.get_node("tags").chests
	inventory.chest.hero = _hero
	inventory.chest.logic = inventory.logic
	inventory.chest.chests = chests
	chests.group = _hero.group
	
	inventory.logic.effect.hero = _hero
	inventory.logic.effect.logic = inventory.logic

	chest.body_entered.connect(inventory.chest.enter_chest)
	chest.body_exited.connect(inventory.chest.exit_chest)
