extends Node

# signal forwarding(velocity: Vector2)
signal directing(direction: Vector2)

@onready var duration: Timer = $duration

var last_velocity: Vector2 = Vector2.ZERO
var flying: bool = false
var box: CharacterBody2D

var _weight: float = 1
var weight: float:
	get: return _weight
	set(value):
		assert(value != 0)
		_weight = value

func make_velocity(next: Vector2) -> void:
	# forwarding.emit(next)
	box.push(next)
	print("PUSH BOX: ", next)
	directing.emit(next.normalized())

func apply_velocity(next: Vector2) -> void:
	if flying: return
	if next != Vector2.ZERO:
		last_velocity = next
	make_velocity(next)

func throw_velocity(power: int) -> void:
	if flying: return
	last_velocity *= power
	make_velocity(last_velocity)
	flying = true
	duration.start()

func throw_velocity_stop() -> void:
	flying = false
	box.velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if flying:
		box.velocity = last_velocity
		last_velocity *= 0.87
