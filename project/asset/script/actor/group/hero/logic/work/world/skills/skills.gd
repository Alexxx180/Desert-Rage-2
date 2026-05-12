class_name SkillManager extends RefCounted

var REF: Dictionary = {}

var pull: SkillPull:
	get: return Works.loads("pull", REF, new_skill_pull)

var _last_position: Vector2

func new_skill_pull() -> SkillPull: return SkillPull.new()
func new_act() -> SkillPull: return SkillPull.new()

var _transition: Node = null
var transition: Node:
	get: return update_act(_transition, "transition")

var _act: Node = null
var act: Node:
	get: return update_act(_act, "act")

var _press: Node = null
var press: Node:
	get: return update_act(_press, "press")
