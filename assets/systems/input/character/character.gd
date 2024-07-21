extends CharacterBody2D

@export var control: bool = false

@onready var size: Node2D = $size
@onready var interaction: StaticBody2D = $interaction
@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func to_platforming():
	platforming.process_mode = Node.PROCESS_MODE_INHERIT
	movement.process_mode = Node.PROCESS_MODE_DISABLED

func to_movement():
	platforming.process_mode = Node.PROCESS_MODE_INHERIT
	movement.process_mode = Node.PROCESS_MODE_DISABLED
