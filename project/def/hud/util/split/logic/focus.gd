extends Node

enum { LOGIC = 0, HOTKEY = 1 }

#func restart_focus(actions: Array[Node]) -> void:
	#for i in range(0, 2): actions[i].restart_delay()

func get_controls_focus(l: SplitToggleLogic, controls: SplitNavigation) -> Array:
	return [[l.focus_straight, controls.panel_focus], [l.focus_backward, controls.tab_focus],
		[l.straight_drag, controls.smooth_direct], [l.backward_drag, controls.smooth_back],
		[l.instant_drag, controls.instant]]

func setup(navigation: Node, focused: Control) -> void:
	navigation.hud.logic.focus = focused# navigation.get_nodes(navigation.focus_paths)
	
	var actions: Array[Node] = get_children()
	var logic: Array = get_controls_focus(navigation.hud.logic, navigation.controls)
	
	for i in range(0, len(logic)):
		actions[i].actions = logic[i][HOTKEY]
		actions[i].feedback.connect(func(): logic[i][LOGIC].call())
	# for i in range(2, 5):
		# actions[i].feedback.connect(func(): restart_focus(actions))
	
	navigation.input.actions = actions




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
