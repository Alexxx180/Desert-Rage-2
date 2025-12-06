extends HBoxContainer

@export var fixed: bool = false

@onready var space: Control = $space
@onready var preset: HBoxContainer = $preset

func _ready() -> void:
	space.title.status.xp.set_fixed(fixed)
	preset.sets.ap.set_fixed(fixed)
