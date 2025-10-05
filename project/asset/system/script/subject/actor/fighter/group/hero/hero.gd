extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node = $logic

func make_velocity(motion: Vector2) -> void: velocity = motion
func make_position(motion: Vector2) -> void: position = motion
