class_name Lockers extends Node

enum { MECH = 0, SOURCE = 2 }

var root: LevelRoot

var _ability: Node = null
var ability: Node:
	get:
		if _ability == null:
			_ability = load(Defaults.now.ability % "ability").instantiate()
			_ability.lockers = self
			add_child(_ability)
		return _ability

var _activator: Node = null
var activator: Node:
	get:
		if _activator == null:
			_activator = load(Defaults.now.activator).instantiate()
			add_child(_activator)
		return _activator
