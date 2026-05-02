extends PanelContainer

@onready var number: ProgressBar = $number
@onready var lasted: ProgressBar = $timing/lasted

const NUMBER: int = 60

func tick(value: int) -> void:
	if value < NUMBER:
		number.text = str(value)
	else:
		number.text = "%d:%02d" % [value / NUMBER, value % NUMBER]
	lasted.value = value
