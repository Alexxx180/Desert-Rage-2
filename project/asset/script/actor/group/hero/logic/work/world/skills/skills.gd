class_name SkillManager extends RefCounted

var REF: Dictionary = {}
# signal activate(pos: Vector2)
func act_busy(hero: CharacterBody2D) -> void:
	# hero.posed = hero.position + hero.act.position
	hero.states("ACTING", true)

func act_stop(hero: CharacterBody2D) -> void: hero.states("ACTING", false)

func pull_busy(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	hero.boxes.push_back(box) #;print("START FORWARD")
	hero.to.moves.jump.pull_box(hero.boxes.size() > 0)
	
	hero.states("GRAB", not hero.to.skills.pull.ledge.is_colliding())
	# or box.compare_height(hero) DEPRECATED
	if hero.do("GRAB"):
		hero.to.topdown.move.act.velocity.weight += box.weight

func pull_stop(hero: CharacterBody2D, box: CharacterBody2D) -> void:
	hero.boxes.erase(box)
	hero.to.moves.jump.pull_box(hero.boxes.size() > 0)

	if hero.do("GRAB"): # print("STOP FORWARD")
		var v: Node = hero.to.topdown.move.act.velocity
		v.weight = max(0, v.weight - box.weight)
		box.logic.work.move.apply_velocity(Vector2.ZERO)

func press_busy(hero: CharacterBody2D) -> void:
	hero.posed = hero.position
	hero.states("STANDING", true)
	#activate.emit(hero.posed, hero)

func press_stop(hero: CharacterBody2D) -> void:
	hero.states("STANDING", false)
	#deactivate.emit(hero.posed, hero)

signal transit(hero: CharacterBody2D)

func transits_busy(hero: CharacterBody2D) -> void:
	transit.emit(hero)

#func _input(_event: InputEvent) -> void:
#	if _allow and Input.is_action_pressed("action"):
#		activate.emit(_last_position)
# func take_effect() -> void: activate.emit(_last_position)
