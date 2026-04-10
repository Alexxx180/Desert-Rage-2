extends Node

func update_act(ref: Node, caption: String) -> Node: return Works.upload(self, ref, Defaults.now.group % caption, caption)

var _stats: MakeStats
var stats: MakeStats:
	get:
		if _stats == null:
			var timer: Timer = Defaults.pre.multiply.instantiate()
			timer.name = "multiply"
			add_child(timer)
			_stats = MakeStats.new(timer)
		return _stats

var _lockers: Node = null
var lockers: Node:
	get: return update_act(_lockers, "lockers")

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
# @onready var push: TileMapLayer = get_node("../push")
