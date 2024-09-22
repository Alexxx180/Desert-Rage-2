extends Node

var _seat: Node

func set_control(seat: Node) -> void:
	_seat = seat
	_seat.on_seat.connect(_hero_events)

func _hero_events(seat: Node, hero: CharacterBody2D, has_hero: bool) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump

	if has_hero:
		_seat.climb.connect(jump.overview.set_floor)
		_seat.move.connect(hero.teleport)
	else:
		_seat.climb.disconnect(jump.overview.set_floor)
		_seat.move.disconnect(hero.teleport)

	signal move(target: Vector2)
	signal on_floor_changed(F: int)
	signal update_view(hero: Sprite2D, status: bool)
