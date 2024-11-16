extends VBoxContainer

@onready var help: Button = $help
@onready var motion: VBoxContainer = $motion

func _on_hide() -> void:
	help.visible = true

func show_help() -> void:
	help.visible = false
	motion.show_hints()

func _input(_event: InputEvent) -> void:
	if !help.visible and Input.is_action_just_pressed("help"):
		motion.hide_hints()

func _ready() -> void:
	motion.on_hidden.connect(_on_hide)
	show_help()
