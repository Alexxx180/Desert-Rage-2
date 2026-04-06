extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/level/zone/build/tilemap/tags/%s.tscn" % caption, caption)

var _stats: MakeStats
var stats: MakeStats:
	get:
		if _stats == null:
			var timer: Timer = Defaults.pre.multiply.instantiate()
			timer.name = "multiply"
			add_child(timer)
			_stats = MakeStats.new(timer)
		return _stats

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

@onready var xp: Node = $xp
@onready var lockers: Node = $lockers
# @onready var push: TileMapLayer = get_node("../push")
