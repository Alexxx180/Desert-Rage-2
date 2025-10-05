extends Node

@onready var move: Node = $move
@onready var fight: Node = $fight
@onready var distance: Node = $distance
@onready var velocity: Node = $velocity

var _hero: CharacterBody2D
var target: Rect2

var hero: CharacterBody2D:
	get: return _hero
	set(value):
		_hero = value
		velocity.hero = _hero
		move.hero = _hero
