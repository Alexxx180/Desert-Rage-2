extends TypeItems

class_name UseTypeItems

enum { N = 0, L1 = 10, L2 = 12, L3 = 15, M = 40 }

func _icon(path: String) -> String: return "items/" + path
func _type(short: String) -> String: return short#.replace("h", "ЖЗ").replace("a", "ОУ")
func _water() -> Dictionary: return o([TEA, ETHER, A_DOTE, A_COUGH])

func _use(power: int, supply: int, type: int = INFINITE) -> IUse:
	return IUse.new(power, supply, type)

func _buff(power: int, supply: int, effect) -> IUse:
	return _use(L3, N, LIMITED).rest("status.m_" + effect)

func _get_effect() -> Array[Dictionary]: return [
		_item("IW", "RC", "jar/water", _use(L1, L1, JAR), _water()),
		_item("IT", "RP", "jar/tea", _use(M, N, JAR), i(TEA)),
		_item("IE", "RP", "jar/ether", _use(N, M, JAR), i(ETHER)),
		_item("IR", "RP", "craft/tamarisk", _use(L3, N), o([TEA])),
		_item("IW", "RP", "craft/tumbleweed", _use(N, L2), o([ETHER])),
		_item("IO", "PT", "craft/opuntia", _buff(L3, N, "poison"), o([A_DOTE])),
		_item("IY", "CT", "craft/yukka", _buff(L2, N, "cough"), o([A_COUGH]))
	]
