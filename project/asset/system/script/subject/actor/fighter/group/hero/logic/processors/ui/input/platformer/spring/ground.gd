extends Node

var _last_spring: Dictionary = Defaults.DICT
var execute: TileMapLayer
var ground: float = 0.0

var is_pressed: bool:
	get: return _last_spring != Defaults.DICT

@onready var deactivation: Timer = $deactivation

func switch_spring_tile() -> void:
	Tile.switch(_last_spring, Vector2i(1, 0), execute)

func activate_spring(hero_pos: Vector2) -> void:
	if not is_pressed:
		_last_spring = Tile.from_pos(execute, hero_pos)
		switch_spring_tile()
		deactivation.start()

func deactivate_spring() -> void:
	if is_pressed:
		switch_spring_tile()
		_last_spring = Defaults.DICT

func save(hero_y: float) -> void: ground = hero_y
