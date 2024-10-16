extends RefCounted

class_name HeroDeploy

var _anchored: bool = false

func anchor(group: Array[Node2D], next: CharacterBody2D) -> void:
	group[0].remove_child(next)
	group[1].add_child(next)
	next.set_owner(group[1])
	next.visible = _anchored

func determine(group: Node2D, party: Array, order: Vector2i) -> void:
	var hero: CharacterBody2D = party[order[0]]
	var next: CharacterBody2D = party[order[1]]
	if _anchored:
		anchor([hero, group], next)
		hero.move.disconnect(next.teleport)
	else:
		anchor([group, hero], next)
		hero.move.connect(next.teleport)
	_anchored = !_anchored
