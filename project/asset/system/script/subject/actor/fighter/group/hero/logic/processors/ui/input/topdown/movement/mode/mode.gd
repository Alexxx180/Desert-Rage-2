extends Node

var type: Node
var hero: CharacterBody2D

@onready var target: Node = $target
@onready var control: Node = $control

func _ready() -> void:
	target.mode = self
	control.mode = self

func end_fight() -> void:
	# print("ENDED!")
	type.distance.perform_motion(hero, hero)
	target.reset_target()
