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
