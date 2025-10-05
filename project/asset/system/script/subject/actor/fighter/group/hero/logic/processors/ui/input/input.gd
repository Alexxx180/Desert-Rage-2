extends Node

@onready var topdown: Node = $topdown
@onready var platformer: Node = $platformer

var is_platformer: bool = false

func _ready() -> void:
	topdown.input = self
	platformer.input = self

func _input(event: InputEvent) -> void:
	if is_platformer:
		platformer.access(event)
	else:
		topdown.access(event)

func _physics_process(delta: float) -> void:
	topdown.process_physics(delta)
	platformer.process_physics(delta)
