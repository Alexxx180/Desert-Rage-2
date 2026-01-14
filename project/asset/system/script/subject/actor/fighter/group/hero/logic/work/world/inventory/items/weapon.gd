extends ArmorItem

class_name WeaponItem

var cross: Array[int]

func _init(_power: int, _equip: Array[int] = [], _effect: String = "attack") -> void:
	super._init(_power, 0, _equip, _effect) # check with at: int in inventory slots

func of(_supply: int) -> WeaponItem:
	supply = _supply
	return self

func crosses(_cross: Array[int]) -> WeaponItem:
	cross = _cross
	return self
