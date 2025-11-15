extends Node

signal update_exp(value: Vector2i, base: int)
signal update_priorities(level: Node, stats: Dictionary)

@onready var stats: Node = $stats
@onready var level: Node = $level

func experience() -> void: update_exp.emit(level.get_exp(), level.priority.base_xp)

func sync_stats() -> void:
	var prior: Dictionary = { "summary": level.summary, "prev": level.prev }
	update_priorities.emit(level, {
		"stats": stats.calculate(level.summary.hero),
		"prev": stats.calculate(level.prev.hero) })

func sync() -> void:
	sync_stats()
	experience()

func add_exp(amount: int) -> void: # print("XP: ", amount, " x %.f" % multiply.last.y, " = ", roundi(amount * multiply.last.y))
	if level.circle_level_up(amount):
		sync_stats()
	experience()
