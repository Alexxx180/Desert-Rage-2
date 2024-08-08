extends Node

@onready var _platforming: Node = $platforming
@onready var _movement: Node = $movement

func set_hero(hero: CharacterBody2D):
	_movement.hero = hero
	_platforming.hero = hero

var platforming: Node.ProcessMode:
	set(mode):
		_platforming.process_mode = mode

var movement: Node.ProcessMode:
	set(mode):
		_movement.process_mode = mode
