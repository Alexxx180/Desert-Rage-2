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

func experience() -> void: update_exp.emit(stats.level.get_exp(), stats.level.priority.base_xp)

func current_stats() -> Dictionary: return stats.calculate(stats.level.summary.hero)

func sync_stats() -> void: # var prior: Dictionary = { "summary": level.summary, "prev": level.prev }
	update_priorities.emit(stats.level, {
		"stats": current_stats(), "prev": stats.calculate(stats.level.prev.hero) })

func sync() -> void:
	sync_stats()
	experience()

func add_exp(amount: int) -> void: # print("XP: ", amount, " x %.f" % multiply.last.y, " = ", roundi(amount * multiply.last.y))
	if stats.level.circle_level_up(amount):
		sync_stats()
	experience()
