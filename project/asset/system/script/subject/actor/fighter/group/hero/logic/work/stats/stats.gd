extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/object/canvas/util/health/%s.tscn" % caption , caption)

var _hud: Node = null
var hud: Node:
	get: return Works.upload(self, _hud, "res://asset/system/scene/subject/actor/group/hero/base/logic/work/hud.tscn", "hud")

var _aura: Node = null
var aura: Node:
	get: return update_act(_aura, "aura")

var _resource: Node = null
var resource: Node:
	get: return update_act(_resource, "resource")

var state: HeroState = HeroState.new()
