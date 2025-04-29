extends FocusedItems

func _ready() -> void:
	var controls: MarginContainer = get_parent() 
	var management: VBoxContainer = controls.get_node("management")
	_topics.push_back(management.mouse.submit)
	_topics.push_back(management.keyboard.options.get_parent())
	_topics.push_back(management.gamepad.options.get_parent())
	_items.push_back(get_mouse(management.mouse))
	_items.push_back(management.keyboard.options.get_items())
	_items.push_back(management.gamepad.options.get_items())
	setup(controls)

func get_mouse(mouse: HSlider) -> Array[Control]:
	grabbed.push_back(mouse)
	mouse.set_neighbor("../mouse", "../keyboard")
	return [mouse.submit]
