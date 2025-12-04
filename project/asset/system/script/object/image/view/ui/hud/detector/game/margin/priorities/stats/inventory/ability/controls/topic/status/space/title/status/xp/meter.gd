extends HBoxContainer

@onready var score: ProgressBar = $score

var fill: StyleBoxFlat = StyleBoxFlat.new()

func new_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			show()
			score.max_value = value.y
			score.value = value.x)

func _next_color(is_combo: bool) -> Color:
	return Color8(196, 150, 18, 255) if is_combo else Color8(100, 100, 175, 255)

func update_color(is_combo: bool) -> void:
	fill.bg_color = _next_color(is_combo)
	score.set("theme_override_styles/fill", fill)
