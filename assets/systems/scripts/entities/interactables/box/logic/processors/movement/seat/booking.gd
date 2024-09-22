extends RefCounted

class_name SeatBooking

signal on_floor_changed(F: int)
signal rollback()
signal remember()
signal move(axis: int, velocity: float)

var status: bool = false

func set_floor(F: int):
	on_floor_changed.emit(F)

func _at_floor(hero: CharacterBody2D) -> bool:
	return hero.processing.platforming.jump.feet.stable

func seating(hero: CharacterBody2D) -> bool:
	return status or _at_floor(hero)

func book(seat: Node, has_hero: bool):
	status = has_hero
	var methods: Array[Array] = [
		[on_floor_changed, seat.set_floor], [move, seat.move],
		[rollback, seat.pos.rollback], [remember, seat.pos.remember]
	]
	if seat.has_hero:
		for m in methods: m[0].connect(m[1])
	else:
		for m in methods: m[0].disconnect(m[1])
