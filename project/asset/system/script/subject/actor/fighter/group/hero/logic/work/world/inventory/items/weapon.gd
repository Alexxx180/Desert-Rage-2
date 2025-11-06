extends ArmorItem

class_name WeaponItem

var cross: Array[int]

func _init(_power: int, _supply: int = 0, _cross: Array[int] = [], _equip: Array[int] = [], _effect: String = "attack") -> void:
	super._init(_power, _supply, _equip, _effect) # check with at: int in inventory slots
	cross = _cross
