extends IKey

class_name IUse

enum { AURA = 0, RESOURCE = 1, AR = 2, BOTH = 3 }

var power: int = 0
var supply: int = 0

func _init(_power: int, _supply: int, spend: int = TypeItems.LIMITED, _effect: String = "status.replenish") -> void:
	super._init(_effect, spend)
	power = _power
	supply = _supply

func rest(name: String) -> IUse:
	buff("status.replenish")
	return self

func same() -> bool: return power == supply
func less() -> bool: return power < supply

func _t(value: int) -> String: return str(value) + " "

func describes(check: Callable, a, b, c, d) -> String:
	if supply == 0: return a.call()
	if power == 0: return b.call()
	if check.call(): return c.call()
	return d.call()

func describe(ui: Node) -> String:
	return describes(same, func(): return _t(power) + ui.r(),
		func(): return _t(supply) + ui.a(),
		func(): return _t(power) + ui.ar(),
		func(): return ui.both() % [power, supply]
	)

func imagine(ui: Control) -> void:
	describes(less, ui.sresource, ui.saura, ui.sresource, ui.saura)
