extends Node

var is_platformer: bool = false
var suspended: bool:
	get: return process_mode == PROCESS_MODE_DISABLED
	set(value): process_mode = PROCESS_MODE_DISABLED if value else PROCESS_MODE_INHERIT

func upload_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/input/type/%s.tscn" % caption, caption)

var _topdown: Node = null
var topdown: Node:
	get:
		return upload_act(_topdown, "topdown")

var _platformer: Node = null
var platformer: Node:
	get: return upload_act(_platformer, "platformer")

func _input(event: InputEvent) -> void:
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
