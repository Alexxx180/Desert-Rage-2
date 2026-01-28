extends BehaviorAction 

@onready var caption: String = get_parent().name

func tick(mark: Tick) -> int: # print("DENIED ACCESS TO SKILLS ! ", mark.actor) # return FAILED #print("hero: ", mark.blackboard.get_value("tools").hero.name)
	var action: Dictionary = mark.blackboard.g(caption) # action.pressed = Input.is_action_pressed(name) # action.toggled = Input.is_action_just_pressed(name)
	action.released = Input.is_action_just_pressed(name)
	if action.released:
		var hero: CharacterBody2D = mark.blackboard.g("tools").hero
		hero.to.topdown.move.act.run.state.atb.decrement()
		# action.tools # print("action: ", action)
		return OK
	return FAILED
