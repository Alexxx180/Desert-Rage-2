extends Node

signal move(next: Vector2)

const height: int = 1
const feedback: int = 2

var platform: CharacterBody2D
var half: Vector2:
	get: return platform.geometry.shape.size / 2

var center: Vector2:
	get: return platform.position#  + half

func compare_height(hero: CharacterBody2D) -> bool:
	return platform.logic.processors.seat.compare(hero)

func push(next: Vector2) -> void:
	platform.velocity = next
	move.emit(platform.position)
	#print("CURRENT POS: ", position)
