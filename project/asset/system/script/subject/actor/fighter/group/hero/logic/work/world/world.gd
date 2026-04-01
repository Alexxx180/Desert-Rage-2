extends Node

func update_act(ref: Node, caption: String) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/base/logic/work/world/%s.tscn" % caption, caption)

func update_ability(ref: Node) -> Node:
	return Works.upload(self, ref, "res://asset/system/scene/subject/actor/group/hero/ray/logic/work/world/ability/ability.tscn", "ability")

var _skills: Node = null
var skills: Node:
	get: return update_act(_skills, "skills")

var _ability: Node = null
var ability: Node:
	get: return update_ability(_ability)

var _inventory: Node = null
var inventory: Node:
	get: return update_act(_inventory, "inventory")

@onready var fight: Node = $fight
@onready var layers: Node = $layers
