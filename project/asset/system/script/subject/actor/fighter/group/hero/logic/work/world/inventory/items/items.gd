extends Resource

class_name GameItems

enum { JAR = 0, WATER = 1, DUMMY = 9, EYE = 22, BONE = 23, BANDAGE = 24, KNIFE = 25, SWORD = 26 }

var items: Array[ItemDescription] = [
	ItemDescription.new("Пустая банка", "Позволяет хранить жидкость", "Находится в сундуках, их наличие значительно облегчает поход."),
	ItemDescription.new("Чистая вода", "+10 ЖЗ +10 ДА. Ингредиент", "Используется для создания водных растворов"),
	ItemDescription.new("Чучело", "Отвлекает противников", "Образец собранный из подручных материалов, позволяет избежать сражения на определенное время."),
]

var weapon: Array[WeaponItem] = [
	WeaponItem.new(50, 20), WeaponItem.new(50, 20)
]

var armor: Array[ArmorItem] = [
	ArmorItem.new(50, 20), ArmorItem.new(50, 20)
]

var item: Dictionary = { "weapon": weapon.size() }

@export var recipe: Dictionary = {
	DUMMY: "Глаз + Кость + Бинт"
}
