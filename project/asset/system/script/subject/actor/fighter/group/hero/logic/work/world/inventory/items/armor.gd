extends RefCounted

class_name ArmorItem

var power: int = 0
var supply: int = 0

var equip: Array[Dictionary] = [{}, {}]

func _init(_power, _supply: int) -> void:
	power = _power
	supply = _supply
