extends HBoxContainer

@onready var enemy: Array[PanelContainer] = [$enemy_1] # , $enemy_2
@onready var combo_node: Array[MarginContainer] = [
	$experience/caption/main/combo, $experience/caption/main/margin
]
@onready var combo: Dictionary = {
	"meter": combo_node[0].get_node("meter"),
	"score": combo_node[1].get_node("multiplier")
}
@onready var count: Label = $experience/caption/main/space/margin/count

# var meter: ProgressBar# scroll/margin/stack/ability/score/exp/total/combo/meter
func set_xp_score(group_xp: Node) -> void:
	var timer: Timer = $hide_xp
	var score: ProgressBar = $experience/meter/margin/next/score
	timer.timeout.connect(func(): count.hide())
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = str(base_xp + value.x)
			count.show()
			timer.start()
			score.max_value = value.y
			score.value = value.x)

func finish() -> void: for node in combo_node: node.hide()

func update_meter(time: float, maximum: float) -> void:
	combo.meter.max_value = maximum
	combo.meter.value = time

func update_multiplier(score: float) -> void:
	for node in combo_node: node.show()
	combo.score.text = "%.2f" % score
