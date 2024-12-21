extends VBoxContainer

@export var help: HelpHint

@onready var caption: Label = $body/margin/caption

func _ready() -> void:
	$head/margin/caption.text = help.head
	caption.text = help.body

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

func sync_control_hint(event: InputEvent) -> void:
	var gamepad: bool = event is InputEventJoypadButton or event is InputEventJoypadMotion
	var device: String = Input.get_joy_name(0).to_lower()
	var hint: String = help.body
	
	if gamepad and device != "":
		var i: int = help.get_gamepad_type(device)
		var hints: Array[String] = help.gamepad[i].hints
		if help.gamepad.size() == 1:
			hint = help.body % hints[0]
		else:
			hint = help.body % hints
	else:
		hint = help.body % help.keyboard
	caption.text = hint
