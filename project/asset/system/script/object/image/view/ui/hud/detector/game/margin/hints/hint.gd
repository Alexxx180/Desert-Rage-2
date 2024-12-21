extends VBoxContainer

@export var help: HelpHint

@onready var caption: Label = $body/margin/caption

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func _ready() -> void:
	$head/margin/caption.text = help.head
	"""
	if is_gamepad_connected():
		caption.text = get_gamepad_hint()
	else:
		caption.text = help.body % help.keyboard
	"""
	caption.text = help.body % help.keyboard

func _change_state(color: Color) -> void:
	create_tween().tween_property(self, "modulate", color, 0.5)

func show_delayed() -> void:
	modulate = Color.TRANSPARENT
	show()
	_change_state(Color.WHITE)
	
func hide_delayed() -> void:
	_change_state(Color.TRANSPARENT)
	await get_tree().create_timer(1).timeout
	hide()
	modulate = Color.WHITE

func get_gamepad_hint() -> String:
	var device: String = Input.get_joy_name(0).to_lower()
	var hint: String = help.body

	if device == "": return hint % help.keyboard

	var i: int = help.get_gamepad_type(device)
	var hints: Array[String] = help.gamepad[i].hints

	if help.gamepad.size() == 1:
		hint = hint % hints[0]
	else:
		hint = hint % hints

	return hint

func sync_control_hint(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		caption.text = get_gamepad_hint()
	else:
		caption.text = help.body % help.keyboard
