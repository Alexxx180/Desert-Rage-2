extends CharacterBody2D

@onready var geometry: CollisionShape2D = $geometry
@onready var view: Node2D = $view
@onready var logic: Node = $logic

func _ready():
	logic.set_control_entity(self)

func teleport(next: Vector2) -> void:
	position = next

func travel(motion: Vector2) -> void:
	velocity = motion
	move_and_slide()
