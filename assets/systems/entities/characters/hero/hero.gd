extends CharacterBody2D

@export var control: bool = false

@onready var stand: Sprite2D = $stand
@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processing: Node = $processing
@onready var geometry: CollisionShape2D = $geometry

func _ready():
	processing.set_control_entity(self)
	detectors.set_control_entity(self)
	stats.set_control_entity(self)
