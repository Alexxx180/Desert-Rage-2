extends Node

@export var influence: int = 1

var pillar: Node
var is_near: bool:
	get: return pillar.ledges.is_near()

func take_effect() -> void:
	pillar.dash_on_whip()
