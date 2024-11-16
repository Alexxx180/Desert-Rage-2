extends MarginContainer

@onready var help: Button = $help
@onready var motion: VBoxContainer = $hints/motion

func _on_hide() -> void:
	help.visible = true

func _on_help_press() -> void:
	help.visible = false
	motion.show_full_hint()

func _ready() -> void:
	motion.on_hidden.connect(_on_hide)
	help.visible = false
	motion.start_progression()
