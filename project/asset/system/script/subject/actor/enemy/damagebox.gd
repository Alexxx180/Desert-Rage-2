extends Area2D

@onready var timer: Timer = $timer

const DAMAGE: int = 5

var close: FightRange = FightRange.new()
var count: int = 0

func _ready() -> void:
	timer.timeout.connect(func(): close.hit(DAMAGE))

func hero_enter(body: StaticBody2D) -> void:
	close.enter_range(body)
	close.hit_initial(body, DAMAGE)
	count += 1
	if count == 1: timer.start()
	
func hero_exit(body: StaticBody2D) -> void:
	close.exit_range(body)
	if count == 1: timer.stop()
	count -= 1
