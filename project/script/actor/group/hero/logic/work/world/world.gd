extends Node

@onready var named: String = get_node("../../../..").name

var hero: CharacterBody2D

func update_act(caption: String, path: String = caption) -> Node:
	return Works.uploads(self, Def.world % path, caption, hero.REF)

var skills: Node:
	get: return update_act("skills", "skills/skills")
var ability: Node:
	get: return Works.uploads(self, Def.input % [named, "ability/ability"], "ability", hero.REF)
var inventory: Node:
	get: return update_act("inventory")
var fight: Node:
	get: return update_act("fight")
