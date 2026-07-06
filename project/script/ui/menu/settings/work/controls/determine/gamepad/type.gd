extends Node

@onready var type: Node = $type

var device: Dictionary = {
	"name": get_first_gamepad_name(),
	"type": KeyAndButtonEscapes.PAD.XBOX
}

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func get_first_gamepad_name() -> String:
	return Input.get_joy_name(0).to_lower()

func coop() -> void: pass # get_connected_joypads()
func determine(event: InputEvent) -> bool:
	if not (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return false
		
	device.name = get_first_gamepad_name()
	if device.name != "":
		device.type = type.get_gamepad_type()
		return true
	return false
