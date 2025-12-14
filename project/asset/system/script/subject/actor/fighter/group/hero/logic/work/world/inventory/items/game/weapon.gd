extends RefCounted

class_name WeaponTypeItems

func get_item(no: int) -> Variant:
	return { "logic": effect[no], "item": names[no] }

func _init() -> void: size = names.size()

var size: int
var effect: Array[WeaponItem] = [
	WeaponItem.new(3), WeaponItem.new(4), WeaponItem.new(4), WeaponItem.new(7),
	WeaponItem.new(5), WeaponItem.new(7), WeaponItem.new(9), WeaponItem.new(3),
	WeaponItem.new(50)
]
var names: Array[Item] = [
	Item.new("К. Кастет", "Б. Оружие", "Усиливает пробивающую силу удара", "weapon/knuckle-duster.svg"),
	Item.new("П. Нож", "Б. Оружие", "Годится чтобы нарезать тортик", "weapon/knife.svg"),
	Item.new("Д. Меч", "Б. Оружие", "Снова сэкономили...", "weapon/sword.svg"),
	Item.new("И. Меч", "Б. Оружие", "Простая игрушка?", "weapon/toy-sword.svg"),
	Item.new("К. Шофилд-45", "О. Оружие", "Простой, надежный револьвер", "weapon/schofield45-colt.svg"),
	Item.new("Пацифист", "О. Оружие", "Мир достается тяжелой ценой", "weapon/pacifist-colt.svg"),
	Item.new("Дробовик", "О. Оружие", "Похоже кто-то обронил", "weapon/shotgun.svg"),
	Item.new("Д. Бумеранг", "Д. Оружие", "Осторожно - это деревянное лезвие не игрушка", "weapon/boomerang.svg"),
	Item.new("Тапок", "Б. Оружие", "Слова излишни", "weapon/shoe.svg"),
]

