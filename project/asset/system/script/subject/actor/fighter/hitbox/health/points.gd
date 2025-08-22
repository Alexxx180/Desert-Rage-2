extends Node

const LIFE_BORDER: int = 0

signal update_bar(current: int)
signal dead()
signal freeze()

var points: float
var maximum: int

var alive: bool:
	get: return points > LIFE_BORDER
var segment: float:
	get: return points / maximum

func setup(next: int) -> void:
	maximum = next
	points = maximum - 50 # TODO TEST JARS
#	update_bar.emit(points)

func revive() -> void: points = maximum
func death() -> void: dead.emit()
func hit() -> void: freeze.emit()

func refill(amount: int = 1) -> void:
	points = min(points + amount, maximum)
	update_bar.emit(points)

func damage(amount: int = 1) -> void:
	points = max(points - amount, LIFE_BORDER)
	update_bar.emit(points)
