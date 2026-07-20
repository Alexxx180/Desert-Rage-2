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



"""
extends Area2D

@export_multiline var plot_text: Array[String] = []

var completed: bool = false

func _plot_unfolding(hero: CharacterBody2D) -> void:
	if completed: return
	completed = true
	print("encounter")
	# hero.logic.work.hud.dialog(plot_text) # TODO FIXME plot text dialogs
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")


extends Area2D

@export var hud: Node

@export_group("Hint preview location")
@export var head: String = ""
@export var body: String = ""

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()
	var category: Node2D = act.get_parent()
	var hints: VBoxContainer = hud.game.detector.game.controls.preview.help.hints
	# .hints

	if head == "": head = category.name
	if body == "": body = name

	print("hide progress")

	hints.progress(head, body)
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")


extends Area2D

@export var hud: Node

func _on_hint_collected(_hero: CharacterBody2D) -> void:
	var act: Node2D = get_parent()

	print("hide progress")
	hud.game.detector.game.controls.preview.help.hints.clear_progress()
	act.call_deferred("remove_child", self)
	call_deferred("queue_free")
"""
