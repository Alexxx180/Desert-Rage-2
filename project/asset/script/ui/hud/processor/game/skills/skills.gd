extends Node

var fight: Node
var panel: PanelContainer

var _selection: bool = false
var selection: bool:
	get: return _selection

var hero: CharacterBody2D

func set_fight(next: CharacterBody2D) -> void:
	hero = next
	fight = hero.logic.work.world.fight

func reveal_aims() -> void:
	fight.reveal_aims()
	panel.hide()
	_selection = true

func hide_aims() -> void:
	fight.hide_aims()
	panel.show()
	_selection = false
