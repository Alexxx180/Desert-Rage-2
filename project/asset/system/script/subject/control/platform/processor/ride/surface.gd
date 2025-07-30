extends Node

signal move(next: Vector2)

enum { FREE = 0, IGNITING = 1, BUSY = 2 }
enum { height = 1, feedback = 2 }

var platform: CharacterBody2D
var half: Vector2:
	get: return platform.geometry.shape.size / 2
var center: Vector2:
	get: return platform.position#  + half

var engine: int = FREE
var igniting: Timer

func free_engine() -> void: engine = FREE
func busy_engine() -> void: engine = BUSY
func ignite_engine() -> void:
	engine = IGNITING
	igniting.start()

func compare_height(hero: CharacterBody2D) -> bool:
	return platform.logic.processors.seat.compare(hero)

func push(next: Vector2) -> void:
	platform.velocity = next
	move.emit(platform.position)
	#print("CURRENT POS: ", position)
