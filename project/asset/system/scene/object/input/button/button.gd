class_name ActionsManager extends RefCounted

var switch: ActionsSwitch = ActionsSwitch.new()

func build_caption(action: String, act: int) -> String:
	return action if act == 0 else str(action, "_", act)

func listen_events(acts: ActionButtonGroup, action: String, impulsed: bool, fixed: bool) -> void:
	switch.reset_time(true)
	switch.reset_power()
	var key: String
	for act in acts.group:
		key = build_caption(action, act.id)
		match act.state:
			ActionButton.STATE.TOGGLED: switch.touch(Input.is_action_just_pressed(key))
			ActionButton.STATE.RELEASED: switch.touch(Input.is_action_just_released(key))
			ActionButton.STATE.PRESSED: switch.touch(Input.is_action_pressed(key))
	if switch.timed: switch.set_power(fixed or impulsed, key)

func listen_groups(actions: ActionButtonComplex, fixed: bool) -> void:
	switch.reset_time(false)
	var i: int = len(actions.complex)
	while (not switch.timed) and (i > 0):
		i -= 1
		listen_events(actions.complex[i], actions.action, not actions.power, fixed)

func listen(actions: ActionButtonComplex, fixed: bool) -> bool:
	listen_groups(actions, fixed)
	switch.give_feedback(fixed)
	return switch.timed

func power(actions: ActionButtonComplex, fixed: bool) -> float:
	listen(actions, fixed)
	return switch.power

func get_axis(left: ActionButtonComplex, right: ActionButtonComplex, fixed: bool) -> float:
	return power(right, fixed) - power(left, fixed)

func get_vector(left: ActionButtonComplex, right: ActionButtonComplex,
	forward: ActionButtonComplex, backward: ActionButtonComplex, fixed: bool) -> Vector2:
	return Vector2(get_axis(left, right, fixed), get_axis(forward, backward, fixed))
