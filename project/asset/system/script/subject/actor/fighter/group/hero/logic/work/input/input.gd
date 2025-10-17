extends Node

@onready var topdown: Node = $topdown
@onready var platformer: Node = $platformer

var is_platformer: bool = false
var suspended: bool = false

func _input(event: InputEvent) -> void:
	if suspended: return
	
	if is_platformer:
		platformer.input(event)
	else:
		topdown.input(event)

func _physics_process(delta: float) -> void:
	if not suspended:
		topdown.process_physics(delta)
		platformer.process_physics(delta)
	#print("hero slides: ", topdown.move.act.run.state.hero.name)
	#topdown.move.act.run.state.hero.move_and_slide()
