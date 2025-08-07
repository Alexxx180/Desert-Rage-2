extends BehaviorAction

# enum SkillBank { PUNCH = 0, KICK = 1, FIRE = 2, WHIP = 3, PUDDLE = 4, SPARK = 5 }

signal skill_two()
signal action()
signal kick()

var actions: Dictionary = {
	"action": action, "run": kick, "skill_two": skill_two
}

func tick(_mark: Tick) -> int:
	for key in actions:
		if Input.is_action_just_pressed(key):
			actions[key].emit()
	return OK
