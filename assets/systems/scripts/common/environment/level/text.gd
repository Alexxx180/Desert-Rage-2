extends Label

@export var secret: String = "Секрет"
@export var opened: String = ""

# Финиш - Победа!, 
# Логово лодыря - Desert Rage - The Hidden Artifact
# Первое демо - Это на новый год

const OPENED: Array[String] = [
	"Неплохо 👍", "Так держать! 🥳",
	"Ловко придумано 🌠", "Мощно 🧨",
	"Ну ты крут 😎", "Чел хорош 🔥"
]

func _ready():
	text = secret
	if opened == "":
		opened = OPENED.pick_random()

func _on_open(_body: CharacterBody2D):
	print("WHY ?")
	text = opened
