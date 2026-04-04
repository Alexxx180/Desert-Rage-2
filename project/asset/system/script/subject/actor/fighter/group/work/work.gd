extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/level/zone/build/tilemap/tags/%s.tscn" % caption, caption)

var _recovery: Timer = null
var recovery: Timer:
	get: return update_act(_recovery, "recovery")

var _books: Node = null
var books: Node:
	get: return update_act(_books, "books")

var _chests: Node = null
var chests: Node:
	get: return update_act(_chests, "chests")

var _enemy: Node = null
var enemy: Node:
	get: return update_act(_enemy, "enemy")

var _transition: Node = null
var transition: Node:
	get: return update_act(_transition, "transition")

@export var casual_mode: bool = false
@export_group("Enemies")
@export_flags_3d_physics var monsters: int
@export_flags_3d_navigation var bosses: int

@onready var xp: Node = $xp
@onready var lockers: Node = $lockers
# @onready var push: TileMapLayer = get_node("../push")
