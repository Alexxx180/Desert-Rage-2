extends Node

func controls(cards: CanvasLayer) -> void:
	var pause: Button = cards.get_node("hud/bottom/pause")
	var menu: VBoxContainer = cards.get_node("hud/menu")
	menu.game
	menu.screen
	menu.help
