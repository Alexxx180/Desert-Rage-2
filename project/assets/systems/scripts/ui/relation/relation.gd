extends Node

var hints: HBoxContainer
var state: HBoxContainer
var button: Button

func controls(cards: CanvasLayer) -> void:
	var ui: Node = cards.get_node("ui")
	var game: Control = cards.get_node("hud/game")
	ui.pause.game = game
	ui.pause.pause = cards.get_node("hud/pause")

	ui.help.hints = game.hints
	ui.help.state = game.state

	menu.screen
	menu.help
