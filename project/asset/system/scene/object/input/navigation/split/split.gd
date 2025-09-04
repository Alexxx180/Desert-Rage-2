extends Node

@export var focus_paths: Array[String] = ["", ""]
@export var controls: SplitNavigation
@onready var actions: Array[Node] = [$panel_focus, $tab_focus,
	$smooth_direct, $smooth_back, $instant]

var mask: Array[int] = []
var focus_nodes: Array[Control] = []

func swap_array_slot(result: Array, j: int, slot: int) -> void:
	var t: int = result[j][slot]
	result[j][slot] = result[j + 1][slot]
	result[j + 1][slot] = t

func bubble_sort(result: Array) -> Array:
	var n: int = result.size()
	for i in range(0, n):
		for j in range(0, n - i - 1):
			if result[j][1] < result[j + 1][1]:
				swap_array_slot(result, j, 0)
				swap_array_slot(result, j, 1)
	return result

func set_complex() -> void:
	var c: SplitContainer = get_parent()
	var l: SplitToggleLogic = c.logic
	var logic: Array[Callable] = [l.focus_element_back, l.focus_element_direct,
		l.smooth_back_drag, l.smooth_direct_drag, l.instant_drag]
	var complex: Array[ActionButtonComplex] = [controls.panel_focus,
		controls.tab_focus, controls.smooth_direct, controls.smooth_back, controls.instant]
	for i in range(0, len(logic)):
		actions[i].actions = complex[i]
		actions[i].feedback.connect(func(): logic[i].call(c))

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

func set_input_order() -> void:
	var weight: Dictionary = {}
	var masked: Array = bubble_sort(set_mask_weight(weight))
	for entry in masked:
		mask.append(entry[0])
		for next in weight[entry[1]]:
			mask.append(next)

func _ready() -> void:
	for path in focus_paths:
		focus_nodes.append(get_node(path))
	set_complex()
	set_input_order()

func _input(event: InputEvent) -> void:
	print("MASK: ", mask)
	for i in mask:
		print("I: ", i)
		if actions[i].listen(event):
			return
