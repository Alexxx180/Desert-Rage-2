extends Label

@onready var modulator: Node = $modulator

func finish() -> void: modulator.disappear(self)

func multiply(x: String) -> String:
	return x.substr(0, x.rfind("0")) + "x" if x[-2] == "0" else x

func update_x(score: float) -> void:
	show()
	text = multiply("%.2fx" % score)

func update_meter(time: float, maximum: float) -> void:
	var portion: float = time / maximum
	material.set("shader_parameter/dissolve_value", portion)
	modulator.appear(self)
