extends HBoxContainer

@onready var space: Control = $space
@onready var preset: HBoxContainer = $preset

func finish() -> void: space.title.status.xp.body.multiplier.finish()
