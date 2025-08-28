extends CharacterBody2D

@onready var view: Node2D = $view
@onready var logic: Node2D = $logic

func _ready() -> void:
	logic.relation.controls(self)

func burn(damage: int) -> void:
	logic.processor.health.burn(damage)

func hit(damage: int) -> void:
	logic.processor.health.hit(damage)
