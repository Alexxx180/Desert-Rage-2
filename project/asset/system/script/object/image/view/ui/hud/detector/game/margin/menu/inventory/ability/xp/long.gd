extends VBoxContainer

@onready var next_score: MarginContainer = $experience/next_score
@onready var combo_node: Array = [
	$experience/total/combo, $experience/multiplier
]
@onready var combo: Dictionary = {
	"meter": combo_node[0].get_node("meter"),
	"score": combo_node[1],
	"next": next_score.get_node("count")
}

func set_xp_score(group_xp: Node) -> void:
	var count: Label = $experience/total/score/count
	var score: ProgressBar = $meter/main/next/score
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = str(base_xp + value.x)
			print("NEXT XP: ", value.y - value.x)
			combo.next.text = str(value.y - value.x)
			score.max_value = value.y
			score.value = value.x)

func finish() -> void: for node in combo_node: node.hide()

func update_meter(time: float, maximum: float) -> void:
	combo.meter.max_value = maximum
	combo.meter.value = time

func update_multiplier(score: float) -> void:
	for node in combo_node: node.show()
	combo.score.text = "%.2f" % score
