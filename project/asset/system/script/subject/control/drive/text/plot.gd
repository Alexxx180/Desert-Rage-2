extends Area2D

@export_multiline var plot_text: Array[String] = []

var completed: bool = false

func _plot_unfolding(hero: CharacterBody2D) -> void:
	if completed: return
	completed = true
	print("encounter")
	hero.logic.processors.hud.dialog(plot_text)
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")
