extends Node

enum { OFF, ON, BOSS, FOE }

var s: Node
var control: int: set = sets
var boss: Array[String] = []

func sets(value: int) -> void: pass

func alive(hp: int) -> bool: return 0 < hp
func has_card() -> bool: return s.get_value(s.CARD) != OFF
func fixate_card(hp: int, title: String) -> bool:
	match s.get_value(s.CARD): 
		BOSS: return alive(hp) and title in boss
		FOE: return alive(hp)
	return false

func prefers(size: int) -> bool:
	var state: int = s.get_value(s.COMBO)
	if state == OFF: return false
	if state == ON: return true
	return size == (state + 1)
