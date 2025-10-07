extends Node

@onready var move: Node = $move
@onready var levels: Node = $levels
@onready var actions: Node = $actions
"""
func access(motion: Vector2) -> void:
	if levels.jump.jumped: return
	levels.jump.perform(motion)
	actions.tick()
"""
func _ready() -> void:
	move.act.levels = levels
	move.act.actions = actions

func input(event: InputEvent) -> void:
	move.device.input(event)

func process_physics(delta: float) -> void:
	if levels.jump.feet.stable:
		move.act.process_physics(delta)

func on_select() -> void: pass
