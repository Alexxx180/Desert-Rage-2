extends Area2D

@export var cards: CanvasLayer

@export_group("Hint preview location")
@export var head: String = ""
@export var body: String = ""

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()
	var category: Node2D = act.get_parent()
	var hints: VBoxContainer = cards.hud.detector.game.margin.hints

	if head == "": head = category.name
	if body == "": body = name

	print("make progress: act '%s' - name '%s'" % [head, body])

	hints.progress(head, body)
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")
