extends Node

signal forwarding(velocity: Vector2)
signal directing(direction: Vector2)

#@onready var forward: ActionTimer = $forward
@onready var platform: CharacterBody2D = get_node("../../..")
@onready var surface: Node = $surface

@export var track: Vector2 = Vector2(-250, 0)

var busy: bool = false

func _ready() -> void:
	surface.platform = platform

func _physics_process(_delta: float) -> void:
	platform.move_and_slide()
	if (busy):
		surface.push(track)
		var ledge: Node2D = platform.logic.detectors.ledge
		if ledge.x.is_colliding() or ledge.y.is_colliding():
			surface.push(Vector2.ZERO)
			print("NOT BUSY!")
			busy = false

func apply_velocity(next: Vector2) -> void:
	forwarding.emit(next)
	directing.emit(next.normalized())
