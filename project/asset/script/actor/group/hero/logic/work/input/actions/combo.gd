@tool
extends BehaviorTree

class_name Skills

enum { PUNCH = 0, KICK = 1, FIRE = 2, WHIP = 3, PUDDLE = 4, SPARK = 5 }
enum { DOUBLE = 2, TRIPLE = 3, FOURTH = 4 }

static var drop: Dictionary:
	get: return { DOUBLE: 0.05, TRIPLE: 0.1, FOURTH: 0.2 }

static var multiplier: Dictionary:
	get: return { DOUBLE: 1.25, TRIPLE: 1.5, FOURTH: 2 }

static var _mask: Dictionary:
	get: return { PUNCH: "P", KICK: "K", WHIP: "W", FIRE: "F", PUDDLE: "D", SPARK: "S" }

static var unicode: Dictionary:
	get: return { PUNCH: "✊", KICK: "🦶", WHIP: "🎣", FIRE: "🔥", PUDDLE: "💧", SPARK: "⚡️" }

static func view_action(slot: int) -> void: print(_mask[slot])
static func view_actions(skills: Array) -> void:
	var text: String = ""
	var mask: Dictionary = _mask
	for skill in skills:
		text += mask[skill] + " - "
	print(text)
