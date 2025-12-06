extends HBoxContainer

@onready var health: Label = $health
@onready var sign: Label = $margin/sign
@onready var value: Label = $value

func change(hp: Node) -> void:
	health.text = str(int(hp.contested))
	var delta: int = int(hp.contested - hp.points)
	if delta < 0:
		sign.text = "+"
		value.text = str(abs(delta))
	else:
		sign.text = "-"
		value.text = str(delta)
