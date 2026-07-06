extends HFlowContainer

@onready var sensitivity: HSlider = $sensitivity
@onready var hands: Button = $hands

func get_items(items: FocusedItems) -> Array[Control]:
	get_mouse(items)
	return [sensitivity.submit, $hands, $legs, $combo,
		$heal, $refresh, $set_skill, $use_skill,
		$set_inventory, $use_inventory, $help]

func get_mouse(items: FocusedItems) -> void:
	items.grabbed.push_back(sensitivity)
	var footer: Button = get_node("../footer")
	for slider in items.grabbed:
		slider.hold_focus.connect(footer.set_controls)
	sensitivity.set_neighbor("../../../header", "../hands")
	hands.focus_neighbor_left = sensitivity.get_neighbor()
