extends Node2D

@onready var secret: Label = $secret
@onready var view: Sprite2D = $view

enum { SHOW = 1, HIDE = 2 }

const TIME: int = 1

const OPENED: PackedStringArray = [
	"Неплохо 👍", "Так держать! 🥳", "Ловко придумано 🌠", "Мощно 💪",
	"Ну ты крут 😎", "Чел хорош 🔥", "Хорошая мысль ✅", "Машина 🦾",
	"Только никому 🤫", "Бомбезно 🧨", "Идеально 🤌", "Молодец 😇",
	"Бу! Испугался? 👻", "Мегамозг 🧠", "Не сдавайся ⛳️", "В яблочко 🎯",
	"Такси! Я застрял 🚕", "Отличный вид 🏙", "Пометь себе 💾",
	"Улыбочку 📷", "Хорошо движешься ⚙️", "Отметим? 😎🎁",
	"А я тут прячусь 😉", "А как ты попал сюда? 🤨", "Картинка 💰",
	"Нелегка доля грузчика 📦", "Знаю, что ты лучший 😏", "Ты потрясающий 🦒",
	"Наш слон 🐘", "Просто мечта ⭐️", "Ты мое солнышко ☀️", "Еще повезет 🍀",
	"А здесь прохладно ❄️", "Дело раскрыто 🔓", "Он меня нашел 📣",
	"Отлично идем 📈", "Это кто-то читает? 📖", "Во закинул ⚓️", "Ракета 🚀",
	"Ну и везунчик 🎲", "Все встало на свои места 🧩", "Продолжаем 🎬",
	"Вручаю медаль 🎖", "Вам грамота 🧧", "Остро-актуальная мысль 🌶",
	"Перекус? 🍏", "Вот это изюминка 🍇", "По сути вкусно 🫑", "Прибрать бы тут 🪣",
	"Варит котелок ведь 🧭", "Тонко 🔬", "Жду свершений 🔭", "Растем 🌱", "Секрет 🕵️‍♂️"
]

func _on_open(body: PhysicsBody2D) -> void:
	if body.is_in_group("enemy"): return

	if secret.text == "": # secret.text = OPENED.pick_random()
		_change_state(view, Color.TRANSPARENT)
	_change_state(secret, Color.WHITE)

func _on_close(body: PhysicsBody2D) -> void:
	if not body.is_in_group("enemy"):
		_change_state(secret, Color.BLACK)

func _change_state(subject: CanvasItem, tint: Color) -> void:
	create_tween().tween_property(subject, "modulate", tint, TIME)
