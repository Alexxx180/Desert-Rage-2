extends StaticBody2D

signal move(next: Vector2)

@onready var view: Sprite2D = $view
@onready var stats: Node = $stats
@onready var processors: Node = $processors
@onready var geometry: Node = $placement

var _delta: float = 0.0

func _ready() -> void:
	processors.set_control_entity(self)
	stats.set_control_entity(self)

func _physics_process(delta: float) -> void:
	_delta = delta

func push(motion: Vector2):
	move_and_collide(motion * _delta)
	move.emit(position)
