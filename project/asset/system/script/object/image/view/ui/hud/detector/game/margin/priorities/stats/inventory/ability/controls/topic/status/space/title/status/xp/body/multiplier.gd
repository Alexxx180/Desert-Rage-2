extends Control

@onready var meter: TextureRect = $meter
@onready var number: Label = $number

const MAX: float = 0.95

func start() -> void: show()
func finish() -> void: hide()

func multiply(x: String) -> String:
	return x.substr(0, x.rfind("0")) if x[-1] == "0" else x

func update_x(score: float) -> void: #if not meter.visible: return
	show()
	number.text = multiply("x%.2f" % score)

func update_meter(time: float, maximum: float) -> void:
	var value: float = MAX - MAX * time / maximum
	meter.texture.fill_to.y = value
	visible = 0 < value and value < MAX
