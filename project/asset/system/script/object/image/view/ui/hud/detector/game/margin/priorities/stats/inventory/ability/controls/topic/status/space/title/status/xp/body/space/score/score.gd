extends Control

@onready var timer: Timer = $timer
@onready var count: TextureRect = $count
@onready var multiplier: Label = $multiplier

var fixed: bool = false

func set_show_xp(group_xp: Node) -> void:
	group_xp.update_exp.connect(
		func(value: Vector2i, base_xp: int):
			count.text = base_xp + value.x
			if not fixed: timer.appear()
			# score.show()
			)
