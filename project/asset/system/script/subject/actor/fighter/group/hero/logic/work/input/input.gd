extends Node

var is_platformer: bool = false

func update_act(ref: Node, caption: String) -> Node: return Works.upload(self, ref, Defaults.now.health % caption, caption)
func upload_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/input/type/%s.tscn" % caption, caption)

var _topdown: Node = null
var topdown: Node:
	get: return upload_act(_topdown, "topdown")

var _platformer: Node = null
var platformer: Node:
	get: return upload_act(_platformer, "platformer")

var _aura: Node = null
var aura: Node:
	get: return update_act(_aura, "aura")

var _resource: Node = null
var resource: Node:
	get: return update_act(_resource, "resource")

func _input(event: InputEvent) -> void:
	if is_platformer:
		platformer.input(event)
	else:
		topdown.input(event)

func _physics_process(delta: float) -> void:
	if not Works.off(self):
		topdown.process_physics(delta)
		# TODO FIXME platformer connect
		# platformer.process_physics(delta)
	#print("hero slides: ", topdown.move.act.run.state.hero.name)
	#topdown.move.act.run.state.hero.move_and_slide()
