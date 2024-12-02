extends Label

@export var secret: String = "Секрет"
@export var opened: String = ""

const OPENED: Array[String] = [
	"Неплохо 👍", "Так держать! 🥳", "Ловко придумано 🌠", "Мощно 💪",
	"Ну ты крут 😎", "Чел хорош 🔥", "Хорошая мысль ✅", "Машина 🦾",
	"Только никому 🤫", "Бомбезно 🧨", "Идеально 🤌", "Молодец 😇",
	"Бу! Испугался? 👻", "Мегамозг 🧠", "Не сдавайся ⛳️", "В яблочко 🎯",
	"Такси! Я застрял 🚕", "Отличный вид 🏙", "Пометь себе 💾",
	"Улыбочку 📷", "Хорошо движешься ⚙️", "Отметим? 😎🎁"
]

func _ready():
	text = secret
	if opened == "":
		opened = OPENED.pick_random()

func _on_open(_body: CharacterBody2D):
	text = opened
