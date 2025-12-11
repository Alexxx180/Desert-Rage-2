extends HBoxContainer

const ATB: Color = Color8(255, 255, 150, 255)
const TIME: float = 0.25

@onready var left: ColorRect = $left
@onready var select: Button = $select
@onready var right: ColorRect = $right

var blocked: bool = false

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

func shows(axis: float, a: ColorRect, b: ColorRect) -> bool:
	if axis < 0:
		b.hide()
		a.show()
	elif axis > 0:
		a.hide()
		b.show()
	else:
		return false
	return true

func set_direction(dir: Vector2) -> bool:
	return shows(dir.x, left, right)

func set_atb(portion: float) -> void:
	acting(portion, left, right)

func set_block() -> void:
	visualize_block(left, right)
