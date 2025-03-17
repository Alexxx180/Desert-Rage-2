extends RefCounted

class_name HeroDeploy

signal traverse_camera(node: Node2D, hero: CharacterBody2D)

const COUNT: int = 2

var party: Array[CharacterBody2D]
var _anchored: bool = false
var _deployed: bool = false
var _main: int = 0
var _next: int:
	get: return (_main + 1) % COUNT
var anchored: bool:
	get: return _anchored

func set_deployed(can_deploy: bool) -> void:
	_deployed = can_deploy

func _set_hero(hero: int, visible: bool) -> void:
	party[hero].visible = visible
	Processors.turn(party[hero], visible)

func _anchor(hero: int) -> void:
	_anchored = !_anchored
	_set_hero(hero, !_anchored)

func _sync(next: int) -> void:
	party[next].position = party[_main].position

func locate(position: Vector2) -> void:
	for hero in party: hero.position = position

func select() -> void:
	if _anchored:
		_set_hero(_main, false)
		_main = _next
		_sync(_main)
		_set_hero(_main, true)

func _logic(hero: int) -> Node:
	return party[hero].logic.processors

func _get_feet(hero: int) -> int:
	return _logic(hero).world.floors.F

func _same_ground() -> bool:
	return _get_feet(_main) == _get_feet(_next)

func determine() -> void:
	if not _same_ground():
		return
	elif _anchored:
		var next: int = _next
		_sync(next)
		_anchor(next)
	elif _deployed:
		_anchor(_next)

func init(group: Node2D, heroes: Array[CharacterBody2D], deployed: bool) -> void:
	party = heroes
	traverse_camera.connect(group.camera.traverse)
	group.camera.deploy.is_near.connect(set_deployed)
	locate(group.position)
	initiate(group)
	
	_deployed = deployed
	if deployed: determine()

func initiate(group: Node2D) -> void:
	var next: int = _next
	traverse_camera.emit(group, party[next])
	Processors.switch_both(_logic(_main), _logic(next))

func regroup() -> void: initiate(party[_main])
