extends RefCounted

class_name TypeItems

enum { INFINITE = 0, LIMITED = 1, JAR = 2 }
enum { TEA = 0, ETHER = 1, A_DOTE = 2, A_COUGH = 3 }

static func spend(spending: int, slot: int, logic: Node) -> bool:
	match spending:
		JAR: return logic.items.replace_item(slot, JAR)
		LIMITED: logic.items.use_item(slot)
	return true

func i(product: int) -> Dictionary: return { "i": product }
func o(resources: Array[int]) -> Dictionary: return { "o": resources }
func recipe() -> Array: return [TEA, ETHER, A_DOTE, A_COUGH]

func crafts(result: Dictionary) -> void:
	for j in recipe(): result[j] = { "i": [], "o": -1 }

func get_item(no: int) -> Dictionary: return effect[no]
func _icon(path: String) -> String: return path + ".svg"
func _type(short: String) -> String: return short

func _items(name: String, type: String, description: String, icon: String, logic: Variant, _craft: Dictionary = Def.DICT) -> Dictionary:
	return { "logic": logic, "item": Item.new(name + "T", _type(type), description, _icon(icon), _craft) }

func _item(name: String, type: String, icon: String, logic: Variant, _craft: Dictionary = Def.DICT) -> Dictionary:
	return _items(name, type, name + "D", icon, logic, _craft)

func _get_effect() -> Array[Dictionary]: return []

func _init() -> void:
	effect = _get_effect()
	size = effect.size()

func in_items(id: int) -> bool: return origin <= id and id < origin + size

var origin: int
var size: int
var effect: Array[Dictionary]
