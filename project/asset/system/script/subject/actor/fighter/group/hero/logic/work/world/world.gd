extends Node

@onready var named: String = get_node("../../../..").name

func update_act(ref: Node, caption: String, path: String = caption) -> Node:
	return Works.upload(self, ref, Defaults.now.world % path, caption)

func update_ability(ref: Node) -> Node:
	return Works.upload(self, ref, Defaults.now.input % [named, "ability/ability"], "ability")

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
