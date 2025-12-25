extends KeyItem

class_name UseItem

enum { AURA = 0, RESOURCE = 1, AR = 2, BOTH = 3 }

var power: int = 0
var supply: int = 0

func _init(_power: int, _supply: int, _spending: Spend = Spend.LIMITED, _effect: String = "status.replenish") -> void:
	super._init(_effect, _spending)
	power = _power
	supply = _supply

func describe() -> int:
	if supply == 0: return AURA
	if power == 0: return RESOURCE
	if power == supply: return AR
	return BOTH
