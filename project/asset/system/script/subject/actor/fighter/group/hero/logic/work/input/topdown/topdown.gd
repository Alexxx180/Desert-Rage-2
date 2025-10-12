extends Node

@onready var move: Node = $move
@onready var levels: Node = $levels
@onready var actions: Node = $actions
"""
func access(motion: Vector2) -> void:
	if levels.jump.jumped: return
	levels.jump.perform(motion)
	actions.tick()
	
	@onready var freeze_input: Dictionary = {
	true: func() -> void:
		input.topdown.move.act.run.reset_run() # input.movement.behavior.move.reset()
		Processors.turn(input, false),
	false: func() -> void:
		Processors.turn(input, true)
}
	
	
"""
func _ready() -> void:
	move.act.levels = levels
	move.act.actions = actions

func input(event: InputEvent) -> void:
	move.device.input(event)

func process_physics(delta: float) -> void:
	# print("HERO VEL: ", move.act.run.state.hero.velocity)
	if levels.jump.feet.stable:
		move.act.process_physics(delta)
	#else:
		#var p = move.act.run.state.hero.view.profile
		#print("profile. Animation: ", p.animation, " - frame: ", p.frame)

func on_select() -> void: pass
