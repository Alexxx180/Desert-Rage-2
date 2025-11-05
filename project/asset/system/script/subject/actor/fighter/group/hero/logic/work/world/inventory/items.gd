extends Resource

class_name GameItems

enum { JAR = 0, WATER = 1, DUMMY = 9, EYE = 22, BONE = 23, BANDAGE = 24 }

@export var items: Array[Dictionary] = [
	{ "stack": 30, "name": "Пустая банка", "short": "Позволяет хранить жидкость", "description": "Находится в сундуках, их наличие значительно облегчает поход." },
	{ "stack": 30, "name": "Чистая вода", "short": "+10 ЖЗ +10 ДА. Ингредиент", "description": "Используется для создания водных растворов" },
	{ "stack": 30, "name": "Чучело", "short": "Отвлекает противников", "description": "Образец собранный из подручных материалов, позволяет избежать сражения на определенное время." }
]

@export var recipe: Dictionary = {
	DUMMY = "recipe": "Глаз + Кость + Бинт"
}
