extends KeyItem

class_name UseItem

var power: int = 0
var supply: int = 0

func _init(_power: int, _supply: int, _spending: Spend = Spend.LIMITED, _effect: String = "status.replenish") -> void:
	super._init(_effect, _spending)
	power = _power
	supply = _supply
