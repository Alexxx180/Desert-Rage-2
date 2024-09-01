extends Label

@export var secret: String = "Секрет"
@export var opened: String = "Неплохо"

func _ready():
	text = secret

func _on_open(_body: CharacterBody2D):
	text = opened
