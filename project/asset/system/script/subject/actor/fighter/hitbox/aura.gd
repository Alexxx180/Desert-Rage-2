extends Node

const EMPTY: int = 0

signal update_bar(current: int)

@export var infinite: bool = false
@onready var timer: Timer = $timer

var bar: TextureProgressBar
var points: float
var maximum: int

func available_skill(cost: int) -> bool:
	return points - cost >= EMPTY

func setup(next: int) -> void:
	maximum = next
	points = maximum

func sync_points() -> void:
	update_bar.emit(points)
	bar.value = points
	bar.show()
	timer.start()

func restore() -> void:
	points = maximum
	sync_points()

func refill(amount: int = 1) -> void:
	if not infinite:
		points = min(points + amount, maximum)
		sync_points()

func use(amount: int = 1) -> bool:
	if not infinite and available_skill(amount):
		points = max(points - amount, EMPTY)
		sync_points()
	return infinite or available_skill(amount)

func diffusion() -> void:
	timer.stop()
	bar.hide()
