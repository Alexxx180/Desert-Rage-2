class_name PlatformingBox extends CharacterBody2D

@export_range(1.5, 3.0, 0.1) var weight: float = 1
@export_range(1, 2, 1) var height: int = 1
@onready var offset: Vector2 = Vector2i(0, -32) * height + Vector2i(0, 14)

var no: int
var ledge: Vector2:
	get: return position + offset
# func _ready() -> void: HUD.level.boxes.controls(self)
func _physics_process(_delta: float) -> void:
	# if HUD.level.boxes.is_sliding(no): # HUD.level.boxes.slide_the_box(self)
	move_and_slide()

func make_velocity(next: Vector2) -> void:
	velocity = next
