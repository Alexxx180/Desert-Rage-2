@tool
extends BehaviorTree

class_name Skills

enum { PUNCH = 0, KICK = 1, FIRE = 2, WHIP = 3, PUDDLE = 4, SPARK = 5 }
enum { DOUBLE = 2, TRIPLE = 3, FOURTH = 4 }

static func view_actions(skills: Array) -> void:
	var text: String = ""
	var mask: Dictionary = { PUNCH: "P", KICK: "K",
		WHIP: "W", FIRE: "F", PUDDLE: "D", SPARK: "S" }
	for skill in skills:
		text += mask[skill] + " - "
	print(text)
