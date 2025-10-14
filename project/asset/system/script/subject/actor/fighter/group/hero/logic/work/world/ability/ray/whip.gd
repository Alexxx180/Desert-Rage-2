extends Node

@export var influence: int = 1

var pillar: Node
var is_near: bool:
	get: return pillar.ledges.is_near()

var achievable: bool:
	get: return pillar.ledges.is_near(true)

func take_effect() -> void:
	print("pillar: ", pillar.name)
	pillar.dash_on_whip()
