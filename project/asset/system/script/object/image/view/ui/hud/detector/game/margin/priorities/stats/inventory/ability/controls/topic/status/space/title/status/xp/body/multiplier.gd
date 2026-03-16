extends Control

@onready var meter: TextureRect = $meter
@onready var number: Label = $number
@onready var modulator: Node = $modulator

const MAX: float = 0.95

func finish() -> void: modulator.disappear(self)

func multiply(x: String) -> String:
	return x.substr(0, x.rfind("0")) + "x" if x[-2] == "0" else x

func update_x(score: float) -> void:
	show()
	number.text = multiply("%.2fx" % score)

func update_meter(time: float, maximum: float) -> void:
	var portion: float = time / maximum
	var value: float = MAX - MAX * portion
	meter.texture.fill_to.y = value
	number.material.set("shader_parameter/dissolve_value", portion)
	modulator.appear(self)
