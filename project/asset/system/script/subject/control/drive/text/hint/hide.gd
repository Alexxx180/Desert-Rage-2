extends Area2D

@export var hud: Node

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()

	print("hide progress")
	hud.game.detector.game.controls.preview.help.help.clear_progress()
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")
