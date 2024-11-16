extends Area2D

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var category: String = get_node("../..").name
	var act: String = get_parent().name
	
	var hints: VBoxContainer = get_node("../../../cards").hints
	var help: VBoxContainer = hints.get_node(category)
	
	print("AND MAGIC?")
	
	if name == "appear":
		hints.help.visible = false
		help.show_progress(act)
	else:
		help.hide_progress(act)
	
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")
