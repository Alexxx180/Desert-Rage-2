extends Node

@onready var manual: Node = $manual
@onready var target: Node = $target

var hero: CharacterBody2D:
	set(value):
		manual.hero = value
		target.hero = value
