extends CharacterBody2D

@onready var stand: Sprite2D = $stand
@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors
@onready var geometry: CollisionShape2D = $geometry

func _ready():
	stats.set_control_entity(self)
	detectors.set_control_entity(self)
	processors.set_control_entity(self)

func repositioning(next: Vector2) -> void:
	position = next

func sliding_flow(delta: float) -> void:
	velocity = stats.run(processors.input) * delta
	move_and_slide()

func accelerate(mach: int):
	stats.mach.value = mach
