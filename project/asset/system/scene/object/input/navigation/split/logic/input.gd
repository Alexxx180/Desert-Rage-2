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
