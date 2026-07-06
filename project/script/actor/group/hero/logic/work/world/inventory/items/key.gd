extends RefCounted

class_name IKey

var effect: String
var spending: int

func _init(_effect: String, spend: int = TypeItems.LIMITED) -> void:
	effect = _effect
	spending = spend

func buff(name: String) -> IKey:
	effect = name
	return self
