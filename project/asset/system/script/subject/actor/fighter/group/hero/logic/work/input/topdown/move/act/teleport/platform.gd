extends Node

@onready var box: Dictionary = { "prev": Defaults.ENTITY, "next": Defaults.ENTITY }

const LANDED: int = 1.0

var hero: CharacterBody2D
var target: Rect2
var delta: Vector2:
	get:
		#target.size if Defaults.entity(box.next) else delta) * part
		if Defaults.entity(box.next):
			"""
			if box_ride():
				print("theory hero pos: ", hero.position)
				print("theory: ", box.prev.ledge - target.position)
				return box.prev.ledge - target.size
			"""
			return target.size
		
		print("next box: ", box.next.ledge)
		if box_ride():
			print("- old box standing: ", box.prev.ledge)
			return box.next.ledge - box.prev.ledge
		else:
			print("- target pos : ", target.position)
			return box.next.ledge - target.position
		# return box.next.ledge - (box.prev.ledge if box_ride() else target.position)

func box_ride() -> bool: return box.prev != Defaults.ENTITY

func is_landed(track: float) -> bool: return track == LANDED

func set_box(next: CharacterBody2D) -> void:
	box.next = next

func _get_track(track: Vector2, prop: String) -> Vector2:
	if box_ride():
		print("added ", prop, " = ", box.prev.get(prop))
		return track - box.prev.get(prop)
	else:
		print("minus hero pos")
		return track - hero.position

func set_target_stand(track: Vector2) -> void:
	if Defaults.entity(box.next):
		track = _get_track(track, "offset")
	else:
		track = _get_track(track, "ledge")
	print("NEXT HERO TRAVEL: ", track)
	target = Rect2(hero.position, track)

func sync_hero_pos(proportion: float) -> void:
	hero.position = target.position + delta * proportion
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
