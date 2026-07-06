extends TypeItems

class_name EquipTypeItems

enum { L1 = 5, L2 = 10, L3 = 15, L4 = 25 }

const E: Dictionary = { "RATE": "fire_rate", "DMG": "damage_increase" }

var items: Array = []

func _icon(path: String) -> String: return "armor/equip/" + path
func e(percent: int, effect: String) -> IEquip: return IEquip.new(effect, percent)

func _get_effect() -> Array[Dictionary]: return [
		_item("IU", "PAS", "butter.svg", e(L1, E.RATE)),
		_item("IF", "PBT", "fire-butter.svg", e(L4, "burn_time"), i(A_DOTE)),
		_item("IG", "PDG", "fasten.svg", e(L1, E.DMG), i(A_COUGH)),
		_item("IM", "PSD", "pump.svg", e(-L2, "spread_decrease")),
		_item("IT", "PDG", "metal-end.svg", e(L3, E.DMG)),
		_item("IA", "PRG", "target.svg", e(L1, "range")),
		_item("IL", "PAS", "cleaner.svg", e(L1, E.RATE)),
		_item("IEA", "PRC", "magazine.svg", e(-L2, "skip_cost"))
	]
