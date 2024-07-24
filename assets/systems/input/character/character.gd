extends CharacterBody2D

@export var control: bool = false

@onready var size: Node2D = $size
@onready var interaction: StaticBody2D = $interaction
@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func set_platforming(mode: ProcessMode):
	platforming.process_mode = mode

func set_movement(mode: ProcessMode):
	movement.process_mode = mode
