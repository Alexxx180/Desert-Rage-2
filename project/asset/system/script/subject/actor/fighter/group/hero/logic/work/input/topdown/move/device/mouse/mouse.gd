extends Node

@onready var manual: Node = $manual
@onready var target: Node = $target

var go_for_target: bool:
	get: return manual.go_for_target

func mouse_input() -> void:
	manual.mouse_input()

var hero: CharacterBody2D:
	set(value):
		manual.hero = value
		target.hero = value
