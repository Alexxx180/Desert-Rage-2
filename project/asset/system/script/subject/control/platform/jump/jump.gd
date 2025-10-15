extends CharacterBody2D

@onready var logic: Node2D = $logic
@onready var view: Node2D = $view
@onready var geometry: CollisionShape2D = $placement

@export var speed: float = 1

var offset: Vector2:
	get: return Vector2(0, -32) #.ZERO#Vector2.ZERO #logic.see.stand.position
var ledge: Vector2:
	get: return position#logic.see.stand.get_ledge_position()
var height: int = 1

func _ready() -> void:
	logic.link.controls(self)
