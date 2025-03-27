extends Button

@export var expanded: bool = false

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

func _ready() -> void:
	if expanded: short.show()
	description.text = get_parent().name
