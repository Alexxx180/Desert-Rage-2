extends Node

@onready var move: Node = $move
@onready var tools: Node = $tools
@onready var actions: Node = $actions

func access(motion: Vector2) -> void:
	move.act.turn_around(motion)
	actions.tick() # TEMP disable for jumping

func process_physics(delta: float) -> void:
	# move.act.process_physics(delta)
	tools.process_physics(delta)

func input(event: InputEvent) -> void:
	move.device.input(event)
"""
func on_select() -> void: #input.gravity.turn_walls_collision(false) # FOR WHIP
	move.act.velocity.forget()
	move.act.turn_around(input.motion)
"""
