extends Node

const LIFE_BORDER: int = 0

signal update_bar(current: int)
signal dead()
signal freeze()

@onready var contest: Timer = $contest

var points: float
var maximum: int
var contested: int

var is_just_dead: bool = false
var is_dead: bool = false

var alive: bool:
	get: return points > LIFE_BORDER
var segment: float:
	get: return points / maximum

func set_contested_health() -> void:
	contested = points

func setup(next: int) -> void:
	contest.timeout.connect(set_contested_health)
	maximum = next
	contested = maximum
	points = next # maximum - 50 # TODO TEST JARS
#	update_bar.emit(points)

func revive() -> void: points = maximum
func death() -> void: dead.emit()
func hit() -> void: freeze.emit()

func refill(amount: int = 1) -> void:
	points = min(points + amount, maximum)
	update_bar.emit(points)
	is_dead = points == LIFE_BORDER

func damage(amount: int = 1) -> void:
	points = max(points - amount, LIFE_BORDER)
	is_just_dead = points == LIFE_BORDER and not is_dead
	if is_just_dead: is_dead = true
	update_bar.emit(points)
	contest.start()
