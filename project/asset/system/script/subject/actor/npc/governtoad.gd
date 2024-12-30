extends Node

signal get_to_my_dudes()
signal calm_down_my_dudes(hero: CharacterBody2D)

@export_multiline var message: String = ""
var my_dudes: String = "Это среда, мои чуваки"
var it_is: int = 0

@onready var dialog: PanelContainer = $dialog
@onready var animation: AnimationPlayer = $animation

const WEDNESDAY: int = 3

func _ready() -> void:
	it_is = Time.get_date_dict_from_system()["weekday"]
	if it_is == WEDNESDAY:
		dialog.set_text(my_dudes)
	else:
		dialog.set_text(message)

func _talk(_hero: CharacterBody2D) -> void:
	if it_is == WEDNESDAY:
		get_to_my_dudes.emit()
	
	animation.play("toad_speech")
	dialog.show()
	
func _idle(hero: CharacterBody2D) -> void:
	if it_is == WEDNESDAY:
		calm_down_my_dudes.emit(hero)
	
	dialog.hide()
