extends RefCounted

class_name SeatBooking

signal on_hero_seat(seat: Node, has_hero: bool)
signal climb(F: int)
signal move(axis: int, velocity: float)

var status: bool = false

func set_floor(F: int):
	on_floor_changed.emit(F)

func _at_floor(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.platforming.jump.feet.stable

func seating(hero: CharacterBody2D) -> bool:
	return status or _at_floor(hero)

func book(seat: Node, has_hero: bool):
	status = has_hero
	on_hero_seat.emit(seat, has_hero)
