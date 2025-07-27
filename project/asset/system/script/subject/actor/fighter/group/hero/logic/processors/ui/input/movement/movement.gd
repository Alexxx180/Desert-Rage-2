extends Node

@onready var behavior: Node = $behavior
@onready var mode: Node = $mode
@onready var type: Node = $type

var hero: CharacterBody2D:
	set(value):
		type.hero = value
		mode.hero = value
		value.movement = mode.control.floating

func _ready() -> void:
	mode.type = type
