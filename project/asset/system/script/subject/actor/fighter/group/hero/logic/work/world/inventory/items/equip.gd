extends KeyItem

class_name EquipItem

var power: float = 0

func _init(_effect: String, _power: float) -> void:
	power = _power
	effect = _effect
