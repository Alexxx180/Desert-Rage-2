extends VBoxContainer

@onready var help: Button = $help
@onready var motion: VBoxContainer = $motion

func _on_hide() -> void:
	help.visible = true

func show_help() -> void:
	motion.toggle_hints()

func _ready() -> void:
	motion.show_help_button.connect(_on_hide)
