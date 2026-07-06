extends Node

signal grab(hero: CharacterBody2D)
signal release(hero: CharacterBody2D)

@onready var move: Node = $move
@onready var press: Node = $press
@onready var fire: Node = $fire

func transport(_pos: Vector2) -> void: pass

func grab_box(hero: CharacterBody2D) -> void: grab.emit(hero)
func release_box(hero: CharacterBody2D) -> void: release.emit(hero)
