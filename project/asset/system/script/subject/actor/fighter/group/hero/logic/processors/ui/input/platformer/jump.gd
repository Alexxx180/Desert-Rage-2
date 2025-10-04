extends Node

@onready var slide: Node = $slide
@onready var spring: Node = $spring

func _ready() -> void:
	spring.control.slide = slide

func control(delta: float) -> void:
	slide.gravity(delta)
	spring.gravity(delta)
	slide.hero.move_and_slide()
