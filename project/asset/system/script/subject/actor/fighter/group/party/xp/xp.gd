extends Node

signal update_exp(value: Vector2i, base: int)
signal update_priorities(level: Node, stats: Dictionary)

var _stats: MakeStats
var stats: MakeStats:
	get:
		if _stats == null:
			var timer: Timer = preload("res://asset/system/scene/subject/actor/group/multiply.tscn").instantiate()
			add_child(timer)
			_stats = MakeStats.new(timer)
		return _stats

@onready var level: Node = $level

func experience() -> void: update_exp.emit(level.get_exp(), level.priority.base_xp)

func current_stats() -> Dictionary: return stats.calculate(level.summary.hero)

func sync_stats() -> void: # var prior: Dictionary = { "summary": level.summary, "prev": level.prev }
	update_priorities.emit(level, {
		"stats": current_stats(), "prev": stats.calculate(level.prev.hero) })

func sync() -> void:
	sync_stats()
	experience()

func add_exp(amount: int) -> void: # print("XP: ", amount, " x %.f" % multiply.last.y, " = ", roundi(amount * multiply.last.y))
	if level.circle_level_up(amount):
		sync_stats()
	experience()
