extends Node

@onready var manual: Node = $manual
@onready var target: Node = $target

func mouse_input() -> void:
	manual.mouse_input()

var hero: CharacterBody2D:
	set(value):
		manual.hero = value
		target.hero = value
