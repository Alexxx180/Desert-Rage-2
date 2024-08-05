extends CharacterBody2D

@export var control: bool = false

@onready var size: Node2D = $base/size
@onready var interaction: StaticBody2D = $detectors/interaction
@onready var floor: Node = $detectors/floor/plain
@onready var platforming: Node = $processing/platforming
@onready var movement: Node = $processing/movement

func set_platforming(mode: ProcessMode):
	platforming.process_mode = mode

func set_movement(mode: ProcessMode):
	movement.process_mode = mode
