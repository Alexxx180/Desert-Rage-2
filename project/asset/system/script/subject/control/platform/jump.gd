extends CharacterBody2D

@onready var logic: Node2D = $logic
@onready var view: Node2D = $view
@onready var geometry: CollisionShape2D = $placement

func _ready() -> void:
	logic.relations.controls(self)
