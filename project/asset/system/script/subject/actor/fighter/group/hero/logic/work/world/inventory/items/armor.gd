extends IUse

class_name IArmor

var equip: Array[int]

func _init(_power: int, _supply: int = 0, _effect: String = "defend") -> void:
	super._init(_power, _supply, TypeItems.INFINITE, _effect)

func aura(value: int) -> IArmor:
	supply = value
	return self

func eqa(value: Array[int]) -> IArmor:
	equip = value
	return self
