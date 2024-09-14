extends Node

signal update_view(hero: Sprite2D, status: bool)

@export_range(0, 2) var height: int = 1

var booked: SeatBooking = SeatBooking.new()
var pos: Positioner = Positioner.new()

func set_floor(F: int):
	pos.hero.detectors.platform.floors.surface.F = F + height

func move(axis: int, velocity: float) -> void:
	pos.hero.position[axis] += velocity

func _at_floor(hero: CharacterBody2D) -> bool:
	return hero.processing.platforming.jump.feet.stable

func set_stand(has_hero: bool) -> void:
	update_view.emit(_hero.stand, status)
	booked.book(self, status)
	# if _at_floor(hero): hero.stand.visible = false

func _should_stand_at(hero: CharacterBody2D) -> void:
	if not (booked.status or _at_floor(hero)):
		pos.hero = hero
		set_stand(true)

func _disable_stand(hero: CharacterBody2D) -> void:
	if booked.status and hero == pos.hero: set_stand(false)
