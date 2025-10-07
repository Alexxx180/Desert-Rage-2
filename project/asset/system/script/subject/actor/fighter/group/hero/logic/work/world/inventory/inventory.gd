extends Node

class_name HeroInventory

enum { JAR = 0, WATER = 1, DUMMY = 9 }

@onready var logic: Node = $logic
@onready var chest: Node = $chest

static func get_items_bank() -> Dictionary:
	return {
		JAR: { "icon": "🫙", "name": "Пустая банка", "short": "Позволяет хранить жидкость",
			"description": "Находится в сундуках, их наличие значительно облегчает поход." },
		WATER: { "icon": "💧", "name": "Чистая вода", "short": "Восполняет ЖЗ и ДА. Ингредиент", "power": 10,
			"description": "Используется для создания водных растворов", "tiny": "+10 ЖЗ +10 ДА" },
		DUMMY: { "icon": "🎃", "name": "Чучело", "short": "Отвлекает противников", "recipe": "Глаз + Кость + Бинт",
			"description": "Образец собранный из подручных материалов, позволяет избежать сражения на определенное время." }
	}

func _ready() -> void:
	var d: int = JAR
	logic.storage = [
		{ "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 },
		{ "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 },
		{ "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 },
		{ "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 }, { "id": d, "x": 0 },
	]
