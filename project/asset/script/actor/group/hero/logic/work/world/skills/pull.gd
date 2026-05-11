class_name SkillPull extends RefCounted

var hero: CharacterBody2D
var _grab: bool = false
var boxes: Array[CharacterBody2D] = []

func start_forward(box: CharacterBody2D) -> void:
	boxes.push_back(box) #;print("START FORWARD")
	hero.to.moves.jump.pull_box(boxes.size() > 0)
	
	_grab = not hero.to.skills.pull.ledge.is_colliding() # or box.compare_height(hero) DEPRECATED
	if _grab:
		hero.to.topdown.move.act.velocity.weight += box.weight

func stop_forward(box: CharacterBody2D) -> void:
	boxes.erase(box)
	hero.to.moves.jump.pull_box(boxes.size() > 0)

	if _grab: # print("STOP FORWARD")
		var v: Node = hero.to.topdown.move.act.velocity
		v.weight = max(0, v.weight - box.weight)
		box.logic.work.move.apply_velocity(Vector2.ZERO)

func apply_velocity(velocity: Vector2) -> void:
	for box in boxes:
		box.logic.work.move.apply_velocity(velocity)
