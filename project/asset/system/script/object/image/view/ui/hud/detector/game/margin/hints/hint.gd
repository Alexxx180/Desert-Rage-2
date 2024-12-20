extends VBoxContainer

@export var help: HelpHint

@onready var caption: Label = $body/margin/caption

func _ready() -> void:
	$head/margin/caption.text = help.head
	caption.text = help.body

func sync_control_hint(event: InputEvent) -> void:
	var gamepad: bool = event is InputEventJoypadButton or event is InputEventJoypadMotion
	var device: String = Input.get_joy_name(0).to_lower()
	
	if gamepad and device != "":
		var i: int = help.get_gamepad_type(device)
		caption.text = help.body % help.gamepad[i].hints
	else:
		caption.text = help.body % help.keyboard
