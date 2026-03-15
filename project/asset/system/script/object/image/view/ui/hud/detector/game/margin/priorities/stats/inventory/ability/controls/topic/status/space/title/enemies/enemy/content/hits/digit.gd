extends Control

# @onready var space: Control = $space
# @onready var count: Label = $count
@onready var timer: Timer = $timer

const MARGIN: int = -30
const TIME: float = 0.6

@onready var margin: Array = [[$a, "top"], [$b, "bottom"]]

var no: int = 0
var digit: int = 0

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

# func set_lamp(state: bool) -> void:
# 	space.visible = state

# func set_tint(count, a: int) -> void: #space.modulate = Color8(255, 255, 255, a) # space.modulate.a8 = a # count.modulate.a8 = a
	# count.modulate = Color8(255, 255, 255, a)

func hide_digit() -> void:
	digit = 0
	for m in margin: m[0].count.text = ''
	# set_lamp(false) # set_tint(60)

func set_disabled_tint() -> void:
	#for i in len(margin):
	set_hide(0) #no # set_tint(60) # set_lamp(false)

func set_hide(n: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(margin[n][0], "modulate", Color.TRANSPARENT, TIME)

func animate(m: MarginContainer, p: String) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(func(v): m.add_theme_constant_override(p, v), MARGIN, 0, TIME)
	# tween.tween_property(m, p, 0, TIME)
	tween.tween_property(m, "modulate", Color.WHITE, 0.1)
	timer.start()

func set_hit_value(m: MarginContainer, p: String, next: int) -> void:
	m.add_theme_constant_override(p, MARGIN)
	digit = next
	m.count.text = str(digit)

func set_digit(next: int) -> void:
	if next != digit:
		margin[0][0].modulate = Color.TRANSPARENT
		# set_hide(no)
		no = (no + 1) % margin.size()
		var m: MarginContainer = margin[0][0]
		var p: String = "margin_" + margin[no][1]
		set_hit_value(m, p, next)
		animate(m, p)
