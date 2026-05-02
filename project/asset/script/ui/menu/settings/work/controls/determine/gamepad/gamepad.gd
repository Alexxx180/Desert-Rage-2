extends Node

var types: Array[Array] = [["ps"], ["xbox"], ["xinput", "nintendo", "stk"]]
var found: bool = false

func determine_model(model: Array, device: String) -> void:
	var no: int = model.size()
	while no > 0 and not found:
		no -= 1 # print(size.x, ", ", size.y, ", ", type[size.x][size.y])
		found = device.contains(model[no])

func determine_type(type: int, device: String) -> int:
	while type > 0 and not found:
		type -= 1 # print("Device: ", device)
		determine_model(types[type], device)
	return type

func get_gamepad_type(device: String) -> KeyAndButtonEscapes.PAD:
	found = false
	return (determine_type(types.size(), device)
		if found else KeyAndButtonEscapes.PAD.XBOX)
