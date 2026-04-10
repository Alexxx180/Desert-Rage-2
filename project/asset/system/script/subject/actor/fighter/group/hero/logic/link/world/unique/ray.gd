extends Node

var _detector: Area2D
var _hero: CharacterBody2D
var tile: TilesBelt = TilesBelt.new(2, 0).add("COMFORTER").add("ADJUSTER").from(2, 3).add("PAGE")

func read_book(execute: TileMapLayer, tile: Dictionary) -> void:
	execute.show_text(tile.coords)
	if tile.atlas.x % 2 == 0:
		tile.atlas.x += 1
		Tile.paint(execute, tile)

func recover(kind) -> void: _hero.group.work.recovery.recover(_hero, kind)

func encourage_message() -> void:
	pass

func determine_static(execute: TileMapLayer) -> void:
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	match tile.atlas:
		tile.AS.PAGE: execute.show_text(tile.coords)
		tile.AS.COMFORTER: recover("hp")
		tile.AS.ADJUSTER: recover("ap")
		tile.AS.ENCOURAGER: encourage_message()
		_: read_book(execute, tile)

func distract(execute: TileMapLayer) -> void:
	execute.hide_text()
	for i in ["hp", "ap"]: execute.recovery.stop_recover(_hero, i)

func controls(hero: CharacterBody2D) -> void:
	_hero = hero
	_detector = hero.logic.see.world.unique
	_detector.body_entered.connect(determine_static)
	_detector.body_exited.connect(distract)
