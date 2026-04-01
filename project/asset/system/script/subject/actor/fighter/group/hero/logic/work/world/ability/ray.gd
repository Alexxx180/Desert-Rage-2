extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/world/ability/%s.tscn" % caption, caption)

var _fire: Node = null
var fire: Node:
	get: return update_act(_fire, "fire")

var _whip: Node = null
var whip: Node:
	get: return update_act(_whip, "whip")
