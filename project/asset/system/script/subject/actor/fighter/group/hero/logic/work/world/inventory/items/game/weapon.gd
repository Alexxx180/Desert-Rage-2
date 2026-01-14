extends TypeItems

class_name WeaponTypeItems

var t: Dictionary = { "M": "Б. Оружие", "F": "О. Оружие", "R": "Д. Оружие" }

func _icon(path: String) -> String: return "weapon/" + path
func _type(type: String) -> String: return t[type]

func _get_effect() -> Array: return [
		WeaponItem.new(3, [0, 1]), WeaponItem.new(4), WeaponItem.new(4), WeaponItem.new(7),
		WeaponItem.new(5), WeaponItem.new(7), WeaponItem.new(9), WeaponItem.new(3),
		WeaponItem.new(50)
	]

func _get_names() -> Array[Item]: return [
		_item("К. Кастет", "M", "Усиливает пробивающую силу удара", "melee/knuckle-duster.svg"),
		_item("П. Нож", "M", "Годится чтобы нарезать тортик", "melee/knife.svg"),
		_item("Д. Меч", "M", "Снова сэкономили...", "melee/sword.svg"),
		_item("И. Меч", "M", "Простая игрушка?", "melee/toy-sword.svg"),
		_item("К. Шофилд-45", "F", "Простой, надежный револьвер", "firearm/schofield45-colt.svg"),
		_item("Пацифист", "F", "Мир достается тяжелой ценой", "firearm/pacifist-colt.svg"),
		_item("Дробовик", "F", "Похоже кто-то обронил", "firearm/shotgun.svg"),
		_item("Д. Бумеранг", "R", "Осторожно - это деревянное лезвие не игрушка", "boomerang.svg"),
		_item("Тапок", "M", "Слова излишни", "melee/shoe.svg"),
	]
