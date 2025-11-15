extends Node

class_name PlayerXP

enum { MAX = 3, MAX_LV = 7, BASE_NEXT = 10 }

const MULTIPLIER: float = 1.2

var next: int = 0
var base_xp: int = 0

func maxed_out(of: Array, priority: int) -> bool: return of[priority] >= MAX_LV

func collecting(summary: Dictionary) -> bool: return next == 0 or summary.xp < next

func shift_priority(i: Dictionary) -> int:
	var maxed: int = 0
	while maxed_out(i.of, i.at) and maxed < MAX:
		maxed += 1
		i.at = (i.at + 1) % MAX
	return maxed

func priorities_end(priority: int) -> void: if priority == MAX: next = 0

func prevent_new_levels(i: Dictionary) -> void: priorities_end(shift_priority(i))

func set_xp(base: int = 0, target: int = BASE_NEXT) -> void:
	base_xp = base
	next = target

func set_next_level_xp() -> void: set_xp(base_xp + next, int(next * MULTIPLIER))

func remember(level: int) -> int:
	for j in range(0, level): set_next_level_xp()
	return 1 if level == MAX_LV else 0

func level_up(i: Dictionary) -> void: i.of[i.at] += 1
