extends Area2D

@export var cards: CanvasLayer

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()

	print("hide progress")
	cards.hud.detector.game.margin.hints.clear_progress()
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")
