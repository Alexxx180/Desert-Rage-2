extends HBoxContainer

const ATB: Color = Color8(255, 255, 150, 255)
const TIME: float = 0.25

@onready var left: ColorRect = $left
@onready var select: Button = $select
@onready var right: ColorRect = $right

var blocked: bool = false
var previous: bool = false

func acting(portion: float, a: ColorRect, b: ColorRect) -> void:
	for i in [a, b]: i.modulate = Color.WHITE * portion

func _turn_to_atb(blocks: Array) -> void:
	for i in blocks: i.color = ATB
	blocked = false

func visualize_block(a: ColorRect, b: ColorRect) -> void:
	var tween = create_tween()
	for i in [a, b]:
		tween.tween_property(i, "color", Color.WHITE, TIME)
	tween.tween_callback(func(): _turn_to_atb([a, b]))
	blocked = true

func _toggle(a: ColorRect, b: ColorRect) -> void: a.hide() ; b.show()

func shows(axis: float, a: ColorRect, b: ColorRect) -> void:
	if axis < 0:
		_toggle(b, a)
	elif axis > 0:
		_toggle(a, b)
	else:
		for i in [a, b]: i.hide()

func set_direction(dir: Vector2) -> void:
	shows(dir.x, left, right)

func set_atb(portion: float) -> void:
	acting(portion, left, right)

func set_block() -> void:
	visualize_block(left, right)
