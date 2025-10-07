extends Node

@onready var topdown: Node = $topdown
@onready var platformer: Node = $platformer

var is_platformer: bool = false

func _input(event: InputEvent) -> void:
	if is_platformer:
		platformer.input(event)
	else:
		topdown.input(event)

func _physics_process(delta: float) -> void:
	topdown.process_physics(delta)
	platformer.process_physics(delta)
	topdown.move.act.run.state.hero.move_and_slide()
