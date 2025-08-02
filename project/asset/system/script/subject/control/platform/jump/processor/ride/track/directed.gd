extends Node

signal forwarding(velocity: Vector2)
signal directing(direction: Vector2)

#@onready var forward: ActionTimer = $forward
@onready var platform: CharacterBody2D = get_node("../../..")
@onready var surface: Node = $surface

var track: Vector2
const POWER: int = 250

func _ready() -> void:
	surface.platform = platform
	surface.igniting = $igniting

func _physics_process(_delta: float) -> void:
	platform.move_and_slide()
	surface.check_engine(self)

func busy_feedback() -> void: pass
func hero_entered(hero: CharacterBody2D) -> void:
	surface.ignite_engine()
	var direction: Vector2 = hero.logic.detectors.platforming.direction
	var x: int = int(direction.x)
	track = Vector2(POWER * x, 0) if x != 0 else Vector2(0, POWER * direction.y)

func ledge_stop(ledge: Node2D) -> bool:
	return (track.y == 0 and ledge.x.is_colliding()) or (track.x == 0 and ledge.y.is_colliding())

func apply_velocity(next: Vector2) -> void:
	forwarding.emit(next)
	directing.emit(next.normalized())
