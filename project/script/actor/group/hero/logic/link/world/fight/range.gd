class_name FightRangeHeader extends RefCounted

var act: Node
var fight: Node

func setup(h: CharacterBody2D, f: Node) -> void:
	act = h.logic.work.world.skills.act ; fight = f

func enter_lever(map: TileMapLayer) -> void:
	act.lever.after_tile.enter_range(map)

func exit_lever(map: TileMapLayer) -> void:
	act.lever.after_tile.exit_range(map)

func enter_book(map: TileMapLayer) -> void:
	act.book.sided.enter_range(map)

func exit_book(map: TileMapLayer) -> void:
	act.book.sided.exit_range(map)

func set_zone(see: Node2D, zone: String) -> void:
	see.get(zone).body_entered.connect(fight.get(zone).enter_range)
	see.get(zone).body_exited.connect(fight.get(zone).exit_range)
