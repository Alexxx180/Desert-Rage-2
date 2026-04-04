extends Node

@onready var layers: Lay = Lay.new()

func update_act(ref: Node, caption: String, path: String = caption) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/base/logic/work/world/%s.tscn" % path, caption)

func update_ability(ref: Node) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/world/ability/ability.tscn", "ability")

var _skills: Node = null
var skills: Node:
	get: return update_act(_skills, "skills", "skills/skills")

var _ability: Node = null
var ability: Node:
	get: return update_ability(_ability)

var _inventory: Node = null
var inventory: Node:
	get: return update_act(_inventory, "inventory")

var _fight: Node = null
var fight: Node:
	get: return update_act(_fight, "fight")
