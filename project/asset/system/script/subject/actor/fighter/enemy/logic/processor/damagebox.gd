extends Node

@onready var timer: Timer = $timer
var damage: int

var close: FightRange = FightRange.new()
var count: int = 0

func setup(next: int) -> void: damage = next

func _ready() -> void:
	timer.timeout.connect(func(): close.hit(damage))

func hero_enter(body: PhysicsBody2D) -> void:
	close.enter_range(body)
	close.hit_initial(body, damage)
	count += 1
	if count == 1: timer.start()
	
func hero_exit(body: PhysicsBody2D) -> void:
	close.exit_range(body)
	if count == 1: timer.stop()
	count -= 1
