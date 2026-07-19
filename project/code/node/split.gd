extends VSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.y * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)

func open_menu(next: int) -> void:
	split_offset = next
	on_drag_end()


extends VSplitContainer

var stack: String = "ability/controls/markers/margin/stack/"

@export var reserve: Array[PackedFloat32Array] = [[-6, -0.5], [-70, -0.5], [-106, -0.5]]
@export var node_paths: Array[Array] = [["../topic/scroll/margin/stack/selection"],
	[stack + "ray", stack + "rock"], [stack + "rock"]]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []
var direction: float:
	get: return reserve[0][1]
var proportion: float:
	get: return get_proportion(direction)

func get_proportion(dir: float) -> float:
	return get_window().size.y * dir

func _ready() -> void:
	for i in range(0, len(node_paths)):
		ui_nodes.append([])
		for path in node_paths[i]:
			ui_nodes[i].append(get_node(path))

func on_drag_end() -> void:
	for i in range(0, len(reserve)):
		var dir: float = reserve[i][1]
		var next: float = float(reserve[i][0] + split_offset)
		logic.drag_feedback(dir, get_proportion(dir), next, ui_nodes[i])



extends HSplitContainer

@export var reserve: int = 6
@export var direction: float = 0.5
@export var node_paths: Array[String] = ["", ""]
@onready var navigation: Node = $navigation

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Control] = []
var proportion: float:
	get: return get_window().size.x * direction

func _ready() -> void:
	for path in node_paths:
		ui_nodes.append(get_node(path))

func on_drag_end() -> void:
	var next: float = float(split_offset + reserve)
	logic.drag_feedback(direction, proportion, next, ui_nodes)





extends Node

@export var controls: SplitNavigation
@export_range(Vector2.Axis.AXIS_X, Vector2.Axis.AXIS_Y, 1) var axis: int

@export_group("Offset")
@export var direction: float = -0.5
@export var reserve: Array = [-6]

@export_group("Paths")
@export var node_paths: Array[Array] = [[""]]
@export var focus_paths: Array[String] = ["", ""]

@onready var input: Node = $input
@onready var focus: Node = $focus
@onready var hud: Node = $hud
@onready var ui: SplitContainer#  = get_parent()

var proportion: float:
	get: return get_window().size[axis] * direction

func face(ax: int, dir: float, res: Array, focused: Control, nodes: Array) -> void:
	axis = ax; direction = dir; reserve = res
	setup(nodes, focused)

func get_nodes(paths: Array) -> Array:
	var nodes: Array = []
	for path in paths: nodes.append(get_node(path))
	return nodes

func setup(nodes: Array, focused: Control) -> void:
	hud.setup(self, nodes)
	focus.setup(self, focused)
	input.set_order()
# func _ready() -> void: setup()





extends Node

var mask: Array[int]
var actions: Array[Node]

func sort_descending(a, b): return a[1] > b[1]

func set_mask_weight(weight: Dictionary) -> Array:
	var masked: Array = []
	for i in range(0, len(actions)):
		var j: int = actions[i].actions.max_button_count
		if weight.has(j):
			weight[j].append(i)
		else:
			weight[j] = []
			masked.append([i, j])
	return masked

func set_order() -> void:
	var weight: Dictionary = {}
	var masked: Array = set_mask_weight(weight)
	masked.sort_custom(sort_descending)
	
	mask = []
	for entry in masked:
		mask.append(entry[0])
		for next in weight[entry[1]]:
			mask.append(next)

func _input(event: InputEvent) -> void:
	for i in mask:
		if actions[i].listen(): # event
			break




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




extends Node

signal resume_input()
signal suspend_input()

@onready var timer: Timer = $suspend

var logic: SplitToggleLogic = SplitToggleLogic.new()
var ui_nodes: Array[Array] = []

func _ready() -> void:
	timer.timeout.connect(drag_feedback)

func setup(navigation: Node, nodes_pack: Array) -> void:
	logic.navigation = navigation
	logic.navigation.ui.drag_ended.connect(on_drag_end)
	logic.navigation.ui.drag_started.connect(on_drag_start)
	for nodes in nodes_pack: # navigation.node_paths:
		ui_nodes.append(nodes)#navigation.get_nodes(paths))

func on_drag_start() -> void:
	print("SUSPEND INPUT")
	suspend_input.emit()

func drag_feedback() -> void:
	print("RESUME INPUT")
	resume_input.emit()

func delay_feedback() -> void:
	timer.start()
	on_drag_start()

func on_drag_end() -> void:
	for i in range(0, len(logic.navigation.reserve)):
		logic.drag_feedback(logic.is_opened_at(i), ui_nodes[i])
	#if not logic.is_opened_last:
	drag_feedback()




extends RefCounted

class_name SplitToggleLogic

var toggled: bool = false
var focus: Control
var navigation: Node
var is_opened_last: bool:
	get: return is_opened_at(-1)
var is_opened_first: bool:
	get: return is_opened_at(0)

enum { STRAIGHT = 0, BACKWARD = 1, MOVE = 3 }

func hide(nodes: Array) -> void: toggle(nodes, "hide")
func show(nodes: Array) -> void: toggle(nodes, "show")
func toggle(nodes: Array, prop: String) -> void:
	for node in nodes:
		var next: String = prop + "s"
		node.get(next if next in node else prop).call()

func open_condition(direction: float) -> Callable:
	return (func(a, b): return a > b) if direction < 0 else (func(a, b): return a < b)

func is_opened_at(item: int) -> bool:
	var n: Node = navigation
	var offset: float = float(n.reserve[item] + n.ui.split_offset)
	# print("OFFSET: ", offset, (" >" if n.direction < 0 else " <"), " PORTION: ", n.proportion)
	return open_condition(n.direction).call(offset, n.proportion)

func drag_feedback(opened: bool, nodes: Array) -> void:
	if opened: hide(nodes)
	else: show(nodes)

func open_menu(next: int) -> void:
	navigation.ui.split_offset = next
	navigation.hud.on_drag_end()

func _get_move(a: int, b: int, dir: float) -> float:
	return MOVE * (a if dir < 0 else b)

func out_screen_drag(condition: bool, offset: float, portion: float) -> void:
	open_menu(int(portion if condition else offset))

func straight_drag() -> void:
	var move: float = _get_move(1, -1, navigation.direction)
	var offset: float = navigation.ui.split_offset + move
	var portion: float = navigation.proportion
	out_screen_drag(offset > portion if move < 0 else offset < portion, offset, portion)
	navigation.hud.delay_feedback()

func backward_drag() -> void:
	var move: float = _get_move(-1, 1, navigation.direction)
	open_menu(navigation.ui.split_offset + move)
	navigation.hud.delay_feedback()

func set_effect(offset: int, focused: int) -> void:
	open_menu(offset)
	_set_focus(focused)

func instant_drag() -> void:
	toggled = !toggled
	if toggled: set_effect(0, STRAIGHT)
	else: set_effect(navigation.proportion, BACKWARD)

func _set_focus(no: int) -> void:
	match no:
		0: focus.grab_focus()

func focus_backward() -> void:
	if not is_opened_first: _set_focus(BACKWARD)

func focus_straight() -> void:
	if is_opened_last: _set_focus(STRAIGHT)
