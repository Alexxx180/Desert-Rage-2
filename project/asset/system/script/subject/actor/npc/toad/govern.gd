extends Node

signal get_to_my_dudes()
signal calm_down_my_dudes(hero: CharacterBody2D)

@export_multiline var message: String = ""

@onready var dialog: PanelContainer = $dialog
@onready var animation: AnimationPlayer = $animation

const my_dudes: String = "Это среда, мои чуваки"
const WEDNESDAY: int = 3
var day: int = 0

func _ready() -> void:
	day = Time.get_date_dict_from_system()["weekday"]
	if day == WEDNESDAY:
		dialog.set_text(my_dudes)
	else:
		dialog.set_text(message)

func say(start: bool, action: Callable) -> void:
	if day == WEDNESDAY: action.call()
	dialog.visible = start

func _talk(_hero: CharacterBody2D) -> void:
	say(true, func(): get_to_my_dudes.emit())
	animation.play("toad_speech")
	
func _idle(hero: CharacterBody2D) -> void:
	say(false, func(): calm_down_my_dudes.emit(hero))
