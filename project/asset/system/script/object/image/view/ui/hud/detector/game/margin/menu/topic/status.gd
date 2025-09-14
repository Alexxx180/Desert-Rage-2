extends HBoxContainer

@onready var enemy: Array[PanelContainer] = [$enemy_1] # , $enemy_2
@onready var combo_node: Array[MarginContainer] = [
	$experience/caption/main/combo, $experience/caption/main/margin
]
@onready var combo: Dictionary = {
	"meter": combo_node[0].get_node("meter"),
	"score": combo_node[1].get_node("multiplier")
}

func finish() -> void: for node in combo_node: node.hide()

func update_meter(time: float, maximum: float) -> void:
	combo.meter.max_value = maximum
	combo.meter.value = time

func update_multiplier(score: float) -> void:
	for node in combo_node: node.show()
	combo.score.text = "%.2f" % score
