extends Node

@onready var topdown: Node = $topdown

var is_platformer: bool = false
var suspended: bool = false

var _platformer: Node = null
var platformer: Node:
	get: return Works.upload(self, _platformer, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/input/actions.tscn", "platformer")

func _input(event: InputEvent) -> void:
	if suspended: return
	
	if is_platformer:
		platformer.input(event)
	else:
		topdown.input(event)

func _physics_process(delta: float) -> void:
	if not suspended:
		topdown.process_physics(delta)
		# TODO FIXME platformer connect
		# platformer.process_physics(delta)
	#print("hero slides: ", topdown.move.act.run.state.hero.name)
	#topdown.move.act.run.state.hero.move_and_slide()
