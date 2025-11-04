extends VBoxContainer

@onready var next_score: Label = $experience/next_score/count

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			next_score.text = str(value.y - value.x))

#func finish() -> void: pass
#func update_meter() -> void: 
