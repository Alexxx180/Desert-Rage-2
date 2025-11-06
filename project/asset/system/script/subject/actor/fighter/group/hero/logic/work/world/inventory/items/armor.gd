extends UseItem

class_name ArmorItem

var equip: Array[int]

func _init(_power: int, _supply: int = 0, _equip: Array[int] = [], _effect: String = "defend") -> void:
	super._init(_power, _supply, _effect) # check with at: int in inventory slots
	equip = _equip
