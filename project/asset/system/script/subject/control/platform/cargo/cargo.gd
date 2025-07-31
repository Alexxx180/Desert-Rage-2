extends CharacterBody2D

@onready var detectors: Node2D = $detectors
@onready var processor: Node = $processor
@onready var relation: Node = $relation

func _ready() -> void:
	relation.controls(self)
