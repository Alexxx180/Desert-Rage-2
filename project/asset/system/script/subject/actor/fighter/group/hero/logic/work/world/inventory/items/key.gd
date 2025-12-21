extends RefCounted

class_name KeyItem

enum Spend { INFINITE = 0, LIMITED = 1, JAR = 2 }

var effect: String
var spending: Spend

func _init(_effect: String, _spending: Spend = Spend.LIMITED) -> void:
	effect = _effect
	spending = _spending
