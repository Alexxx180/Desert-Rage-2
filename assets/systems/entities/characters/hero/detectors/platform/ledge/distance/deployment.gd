extends Node2D

var hero: CharacterBody2D

@onready var walls: ShapeCast2D = $walls
@onready var floors: Area2D = $floors

func disable():
	floors.process_mode = Node.PROCESS_MODE_DISABLED

func detect(target: Vector2) -> void:
	position = target
	floors.process_mode = Node.PROCESS_MODE_INHERIT
