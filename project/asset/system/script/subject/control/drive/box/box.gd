extends CharacterBody2D

signal move(next: Vector2)

@export_range(0.2, 2.0, 0.1) var weight: float = 1
@export_range(1, 2, 1) var height: int = 1

@onready var view: Node2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

const feedback: int = 2

@onready var half: Vector2 = geometry.shape.size / 2

var center: Vector2:
	get: return position + half

func _ready() -> void:
	logic.relations.controls(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func push(next: Vector2) -> void:
	velocity = next
	move.emit(position)
