extends Node

@onready var box: Dictionary = { "prev": Defaults.ENTITY, "next": Defaults.ENTITY }

const LANDED: int = 1.0

var hero: CharacterBody2D
var target: Rect2
var delta: Vector2:
	get: return box.next.ledge - (box.prev.ledge if box_ride() else target.position)

func box_ride() -> bool: return box.prev != Defaults.ENTITY

func is_landed(track: float) -> bool: return track == LANDED

func set_box(next: CharacterBody2D) -> void:
	box.next = next

func set_target_stand(track: Vector2) -> void:
	track -= box.prev.ledge if box_ride() else hero.position
	print("NEXT HERO TRAVEL: ", track)
	target = Rect2(hero.position, track)

func _get_track(part: float) -> Vector2:
	return (target.size if Defaults.entity(box.next) else delta) * part

func sync_hero_pos(proportion: float) -> void:
	hero.position = target.position + _get_track(proportion)
	print("sync hero pos: ", hero.position)

func reposition(pos: Vector2, platform: CharacterBody2D) -> void:
	hero.position = pos
	box.prev = platform
	hero.to.jump.feet.floors.entity = platform

func reparent_hero(prev: Node2D, next: Node2D) -> void:
	prev.remove_child(hero)
	next.add_child(hero)

func _jump_from_platform() -> void:
	reparent_hero(box.prev.view, hero.group)
	reposition(box.prev.ledge + target.size, Defaults.ENTITY)

func _jump_to_platform() -> void:
	if Defaults.entity(box.prev):
		reparent_hero(hero.group, box.next.view)
	else:
		reparent_hero(box.prev.view, box.next.view)
	reposition(box.next.offset, box.next)

func decide_jump() -> void:
	if box.next != Defaults.ENTITY:
		_jump_to_platform()
		return 

	if box_ride():
		_jump_from_platform()
