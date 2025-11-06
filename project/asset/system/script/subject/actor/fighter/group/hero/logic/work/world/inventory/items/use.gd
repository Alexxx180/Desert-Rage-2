extends RefCounted

class_name UseItem

var power: int = 0
var supply: int = 0

func _init(_power: int, _supply: int, _effect: String = "replenish") -> void:
	power = _power
	supply = _supply
	_effect = _effect
