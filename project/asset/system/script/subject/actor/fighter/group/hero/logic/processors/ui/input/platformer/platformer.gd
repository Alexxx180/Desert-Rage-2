extends Node

@onready var move: Node = $move
@onready var spring: Node = $spring

var input: Node

func access(motion: Vector2) -> void:
	move.act.turn_around(motion)
	input.actions.tick(self, input.board) # TEMP disable for jumping

func process_physics(delta: float) -> void:
	input.movement.behavior.move.process_physics(delta)

func on_select() -> void: #input.gravity.turn_walls_collision(false) # FOR WHIP
	move.act.velocity.forget()
	move.act.turn_around(input.motion)
