extends Control

@onready var margin: Array = [$a, $b, $c]
@onready var timer: Timer = $timer

const MARGIN: int = 25
const TIME: float = 0.6

var delayed: bool = false
var digit: int = 0
var cycle: int = 0

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

func hide_digit() -> void:
	digit = 0
	for m in margin: m.count.text = ''
	delayed = false

func set_disabled_tint() -> void: for i in len(margin): set_hide(i)

func _modulate(tween: Tween, m, color) -> void:
	tween.tween_property(m, "modulate", color, TIME)

func set_hide(n: int) -> void:
	var tween: Tween = create_tween()
	_modulate(tween, margin[n], Color.TRANSPARENT)

func animate(no: int) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(func(v): set_margin(margin[no], v), MARGIN, -MARGIN, TIME)
	timer.start()

func set_margin(m: MarginContainer, v) -> void:
	m.modulate = Color8(255, 255, 255, 255 / MARGIN * (MARGIN - abs(v)))
	m.add_theme_constant_override("margin_top", -v)
	m.add_theme_constant_override("margin_bottom", v)
	if v == 8: delayed = false #cycle = min(cycle + 1, 1) #-20
	# if v <= -25 and delayed: delayed = false

func set_hit_value() -> void:
	margin[cycle].add_theme_constant_override("margin_top", -MARGIN)
	margin[cycle].add_theme_constant_override("margin_bottom", MARGIN)
	margin[cycle].count.text = str(digit)

func set_digit(next: int) -> void:
	if next != digit and not delayed: # and cycle > Defaults.INT
		delayed = true
		digit = next
		margin[cycle].modulate = Color.TRANSPARENT
		set_hit_value() # m
		animate(cycle)
		cycle = (cycle + 1) % len(margin)
