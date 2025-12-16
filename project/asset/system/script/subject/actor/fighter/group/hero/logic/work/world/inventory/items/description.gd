extends RefCounted

class_name Item

enum { TEA = 0, ETHER = 1, A_DOTE = 2, A_COUGH = 3 }

var name: String
var short: String
var description: String
var icon: String
var craft: Dictionary

static func i(product: int) -> Dictionary: return { "i": product }
static func o(resources: Array[int]) -> Dictionary: return { "o": resources }

static func crafts(result: Dictionary) -> void:
	for i in [TEA, ETHER, A_DOTE, A_COUGH]:
		result[i] = { "i": [], "o": -1 }

func _init(_name: String, _short: String, _desc: String, _icon: String, _craft: Dictionary = Defaults.DICT) -> void:
	name = _name
	short = _short
	description = _desc
	icon = _icon
	craft = _craft
