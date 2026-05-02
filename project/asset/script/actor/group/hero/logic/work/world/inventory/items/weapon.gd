extends IArmor

class_name IWeapon

var cross: Array[int]

func _init(_power: int, _effect: String = "attack") -> void:
	super._init(_power, 0, _effect)

func eqw(value: Array[int]) -> IWeapon:
	eqa(value)
	return self

func of(_supply: int) -> IWeapon:
	supply = _supply
	return self

func crosses(_cross: Array[int]) -> IWeapon:
	cross = _cross
	return self
