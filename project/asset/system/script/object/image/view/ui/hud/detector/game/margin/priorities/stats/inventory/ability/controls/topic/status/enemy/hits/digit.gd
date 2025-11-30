extends Control

@onready var space: Control = $space
@onready var count: Label = $count
@onready var timer: Timer = $timer

var digit: int = 0

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

func set_lamp(state: bool) -> void:
	space.visible = state

func set_tint(a: int) -> void:
	#space.modulate = Color8(255, 255, 255, a)
	count.modulate = Color8(255, 255, 255, a)
	# space.modulate.a8 = a
	# count.modulate.a8 = a

func hide_digit() -> void:
	digit = 0
	count.text = ''
	set_lamp(false)
	set_tint(60)

func set_disabled_tint() -> void:
	set_tint(60)
	set_lamp(false)

func set_digit(next: int) -> void:
	if next != digit:
		digit = next
		count.text = str(digit)
		count.show()
		set_tint(255)
		set_lamp(true)
		timer.start()
