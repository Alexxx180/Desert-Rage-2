extends RefCounted

class_name HeroDeploy

var _anchored: bool = false

func anchor(group: Node2D, hero: CharacterBody2D, next: CharacterBody2D) -> void:
	group.remove_child(next)
	hero.add_child(next)
	next.set_owner(hero)
	hero.move.connect(next.teleport)
	next.visible = false

func unanchor(group: Node2D, hero: CharacterBody2D, next: CharacterBody2D) -> void:
	hero.remove_child(next)
	group.add_child(next)
	next.set_owner(group)
	hero.move.disconnect(next.teleport)
	next.visible = true

func determine(group: Node2D, party: Array, order: Vector2i) -> void:
	var hero: CharacterBody2D = party[order[0]]
	var next: CharacterBody2D = party[order[1]]
	if _anchored:
		unanchor(group, hero, next)
	else:
		anchor(group, hero, next)
	_anchored = !_anchored
