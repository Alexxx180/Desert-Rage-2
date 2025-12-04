extends HBoxContainer

@onready var space: Control = $space
@onready var multiplier: Control = $multiplier
@onready var timer: Timer = $timer

func set_hide_xp() -> void:
	timer.timeout.connect(func():
		space.score.hide()
		multiplier.hide())

func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			space.score.count.text = str(base_xp + value.x)
			space.score.show()
			timer.start())
