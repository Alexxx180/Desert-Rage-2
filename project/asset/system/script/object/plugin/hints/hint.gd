extends Resource

class_name HelpHint

@export_group("Manual help")
@export var head: String = ""
@export_multiline var body: String = ""

@export_group("Device hints")
@export var keyboard: Array[String]
@export var gamepad: Array[GamepadHints]
@export var screen: Array[String]

func get_gamepad_type(device: String) -> int:
	var type: Array[Array] = [["ps"], ["xbox"], ["xinput", "nintendo"]]

	var size: Vector2i = Vector2i(type.size(), 0)
	var found: bool = false
	
	while size.x > 0 and not found:
		size.x -= 1
		size.y = type[size.x].size()
		while size.y > 0 and not found:
			size.y -= 1
			found = device.contains(type[size.x][size.y])

	return size.x if found else 1
