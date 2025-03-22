extends Node

@export var use_hero_name: bool = false
@export var wednesday_text: String = ""
@export_multiline var message: String = ""

@onready var dialog: PanelContainer = $dialog
@onready var animation: AnimationPlayer = $animation

var names: Dictionary

func _ready() -> void:
	names = { "ray": "Рэй", "rock": "Рок" }
	use_hero_name = use_hero_name and message.contains("%s")

func _show_dialog() -> void:
	animation.play("toad_speech")
	dialog.show()

func _talk(hero: CharacterBody2D) -> void:
	if use_hero_name:
		dialog.set_text(message % names[hero.name])
	else:
		dialog.set_text(message)
	_show_dialog()

func _it_is_wednesday() -> void:
	dialog.set_text(wednesday_text)
	_show_dialog()

func _idle(_hero: CharacterBody2D) -> void:
	dialog.hide()
