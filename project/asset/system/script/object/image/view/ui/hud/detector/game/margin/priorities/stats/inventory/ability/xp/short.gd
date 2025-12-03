extends VBoxContainer

@onready var score: ProgressBar = $meter/margin/next/space/score
@onready var combo_node: Array = [
	$main/multiplier/margin, $main/multiplier/margin/multiplier
]
@onready var combo: Dictionary = {
	"meter": combo_node[0].get_node("meter"),
	"score": combo_node[1]
}

func set_xp_score(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			score.max_value = value.y
			score.value = value.x)

func finish() -> void: for node in combo_node: node.hide()

func update_meter(time: float, maximum: float) -> void:
	combo.meter.max_value = maximum
	combo.meter.value = time

func update_multiplier(score: float) -> void:
	for node in combo_node: node.show()
	combo.score.text = "%.2f" % score
