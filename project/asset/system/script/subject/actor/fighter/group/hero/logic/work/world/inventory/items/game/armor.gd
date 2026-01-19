extends TypeItems

class_name ArmorTypeItems

func _icon(path: String) -> String: return "armor/" + path
func _def(value: int) -> IArmor: return IArmor.new(value)

func _get_effect() -> Array[Dictionary]: return [
		_item("IN", "AC", "pants/pants.svg", _def(1).aura(1)),
		_item("IV", "AA", "pants/greaves.svg", _def(3)),
		_item("IH", "AC", "boots/leather.svg", _def(1)),
		_item("IB", "AA", "boots/iron.svg", _def(2)),
		_item("IK", "AC", "jacket/leather.svg", _def(2)),
		_item("IP", "AA", "jacket/iron.svg", _def(5)),
		_item("II", "AR", "artifact/shield.svg", _def(2)),
		_item("IWD", "AR", "artifact/tooth.svg", _def(0).aura(10))
	]
