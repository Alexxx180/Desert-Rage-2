class_name Lockers extends Node

enum { MECH = 0, SOURCE = 2 }

var root: LevelRoot

func set_lockers(_ability: Node) -> void: _ability.lockers = self

var ability: Node:
	get: return Works.uploads(self, LoadBus.ability % "ability", "ability", set_lockers)

var activator: Node:
	get: return Works.uploads(self, LoadBus.activator, "activator")
