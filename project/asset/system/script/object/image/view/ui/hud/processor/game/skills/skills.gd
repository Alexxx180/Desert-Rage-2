extends Node

var fight: Node
var panel: PanelContainer

var _selection: bool = false
var selection: bool:
	get: return _selection

func set_fight(hero: CharacterBody2D) -> void:
	fight = hero.logic.processors.world.fight

func reveal_aims() -> void:
	fight.reveal_aims()
	panel.hide()
	_selection = true

func hide_aims() -> void:
	fight.hide_aims()
	panel.show()
	_selection = false
