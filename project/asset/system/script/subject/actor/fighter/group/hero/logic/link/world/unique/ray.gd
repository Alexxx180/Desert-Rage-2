extends Node

var _detector: Area2D
var _hero: CharacterBody2D
var category: String = ""
var tile: TilesBelt = TilesBelt.new(2, 0).add("COMFORTER").add("ADJUSTER").from(2, 3).add("PAGE")

func read_book(execute: TileMapLayer, tile: Dictionary) -> void:
	execute.show_text(tile.coords)
	if tile.atlas.x % 2 == 0:
		tile.atlas.x += 1
		Tile.paint(execute, tile)

func set_category(kind) -> void:
	category = kind
	_hero.group.work.recovery.recover(_hero, category)

func encourage_message() -> void:
	pass

func determine_static(execute: TileMapLayer) -> void:
	category = ""
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	match tile.atlas:
		tile.AS.PAGE: execute.show_text(tile.coords)
		tile.AS.COMFORTER: set_category("hp")
		tile.AS.ADJUSTER: set_category("ap")
		tile.AS.ENCOURAGER: encourage_message()
		_: read_book(execute, tile)

func distract(execute: TileMapLayer) -> void:
	execute.hide_text()
	if category != "":
		execute.recovery.stop_recover(_hero, category)
		category = ""

func controls(hero: CharacterBody2D) -> void:
	_hero = hero
	_detector = hero.logic.see.world.unique
	_detector.body_entered.connect(determine_static)
	_detector.body_exited.connect(distract)
