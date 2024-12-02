extends Area2D

signal feedback()

func _available(hero: CharacterBody2D) -> void:
	hero.logic.processors.input.action.connect(interact)
	#print("AVAILABLE TO INTERACT")

func _unavailable(hero: CharacterBody2D) -> void:
	hero.logic.processors.input.action.disconnect(interact)
	#print("UNAVAILABLE TO INTERACT")

func interact() -> void: feedback.emit()
