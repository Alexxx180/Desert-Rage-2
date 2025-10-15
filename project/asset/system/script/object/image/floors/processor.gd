extends Node

@onready var entity: CharacterBody2D = Defaults.ENTITY

var border: TileDecorator
var hero: CharacterBody2D
var F: int: get = get_floor
var _state: Dictionary = { "position": Vector2.ZERO, "height": 0 }
var state: Variant: get = get_state

func get_state() -> Variant:
	if entity == Defaults.ENTITY:
		print("ENTITY is LEDGE")
		_state.position = hero.position
		return _state
	print("ENTITY is BOX")
	return entity

func get_floor() -> int: return extract(state)

func extract(sub: Variant) -> int:
	return border.extract_at_pos(sub.position, Tile.FLOOR) + sub.height

func same(sub: Variant) -> bool:
	var f: int = extract(sub)#; print("F: ", f, " ", "=" if f == F else ("<" if f < F else ">"), " ", F, " ")
	print("HERO F: ", F, " and BOX f: ", f, ", but height: ", sub.height)
	return f == F

func same_to_hero(ground: Vector2) -> bool:
	var _s: Variant = state
	var pos: Vector2 = _s.ledge if "ledge" in _s else _s.position
	print("SEE A FLOOR: ", pos + ground)
	return same({ "position": pos + ground, "height": 0 }) # hero
