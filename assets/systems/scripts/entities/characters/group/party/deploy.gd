extends RefCounted

class_name HeroDeploy

var _anchored: bool = false
var _available: bool = false

var anchored: bool:
	get: return _anchored

func set_available(can_deploy: bool) -> void:
	_available = can_deploy

func _activate(hero: CharacterBody2D, condition: bool) -> void:
	hero.visible = condition
	Processors.turn(hero, condition)

func _anchor(next: CharacterBody2D) -> void:
	_anchored = !_anchored
	_activate(next, !_anchored)

func _sync(hero: CharacterBody2D, next: CharacterBody2D) -> void:
	next.position = hero.position

func select(party: Array[CharacterBody2D], order: Vector2i) -> void:
	if not _anchored: return
	var hero: CharacterBody2D = party[order[0]]
	var next: CharacterBody2D = party[order[1]]
	_sync(hero, next)
	_activate(hero, false)
	_activate(next, true)

func determine(party: Array[CharacterBody2D], order: Vector2i) -> void:
	var next: CharacterBody2D = party[order[1]]
	if _anchored:
		_sync(party[order[0]], next)
		_anchor(next)
	elif _available:
		_anchor(next)
