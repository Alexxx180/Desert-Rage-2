extends Node

@onready var movement: Node = $movement

func controls(box: CharacterBody2D) -> void:
	movement.controls(box, box.logic.processors.movement)
