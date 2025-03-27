extends Button

@export var expanded: bool = false

@onready var short: Control = $short

func _ready() -> void:
	short.set_active(expanded)
