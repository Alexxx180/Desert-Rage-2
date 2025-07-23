extends Node

func controls(hud: CanvasLayer, inventory: VSplitContainer) -> void:
	var processor: Node = hud.processor.game.inventory
	processor.inventory = inventory
	processor.markers = inventory.get_node("ability/controls/markers")
