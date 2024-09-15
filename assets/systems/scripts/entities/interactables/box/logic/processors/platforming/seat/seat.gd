extends Node

signal update_view(hero: Sprite2D, status: bool)

@export_range(0, 2) var height: int = 1

const OFFSET: Vector2 = Vector2(0, 32)

var booked: SeatBooking = SeatBooking.new()
var pos: Positioner = Positioner.new()

func move(target: Vector2) -> void:
	pos.move(target + OFFSET)

func set_floor(F: int):
	pos.hero.detectors.platform.floors.surface.F = F + height

func set_stand(status: bool) -> void:
	update_view.emit(pos.hero.stand, status)
	booked.book(self, status)
	# if _at_floor(hero): hero.stand.visible = false

func enable_stand(hero: CharacterBody2D) -> void:
	if not booked.seating(hero):
		pos.hero = hero
		set_stand(true)

func disable_stand(hero: CharacterBody2D) -> void:
	if booked.status and hero == pos.hero: set_stand(false)
