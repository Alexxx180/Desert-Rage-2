extends Node

@onready var xp: Node = $xp
@onready var hp: Node = $hp

func controls(hud: CanvasLayer, group: Node2D, game: Control) -> void:
	xp.controls(hud, group, game)
	hp.controls(group, game)
