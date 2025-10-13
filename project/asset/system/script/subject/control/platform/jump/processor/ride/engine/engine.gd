extends Node

signal move(next: Vector2)

enum { FREE = 0, IGNITING = 1, BUSY = 2 }

const INVERSE: Vector2 = Vector2(-1, -1)

@export var track: Vector2 = Vector2(-250, 0)

@onready var motion: Vector2 = track
var platform: CharacterBody2D
var state: int = FREE

func set_busy(next: int = BUSY) -> void: state = next
func ignite() -> void: set_busy(IGNITING)
func inverse_track() -> void:
	motion *= INVERSE
	track = motion

func push(motion: Vector2 = track) -> void:
	platform.velocity = track
	move.emit(platform.position)

func set_ledge() -> void:
	#if 
	if platform.logic.see.ledge.is_colliding():
		track = Vector2.ZERO
		push()
		set_busy(FREE)
		inverse_track()
		platform.logic.work.ride.surface.ignite_engine()
