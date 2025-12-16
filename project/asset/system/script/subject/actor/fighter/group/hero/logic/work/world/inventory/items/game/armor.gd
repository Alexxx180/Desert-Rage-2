extends TypeItems

class_name ArmorTypeItems

var t: Dictionary = { "C": "Одежда", "A": "Броня", "R": "Реликвия" }

func _type(short: String) -> String: return t[short]
func _icon(path: String) -> String: return "armor/" + path

func _get_effect() -> Array: return [
		ArmorItem.new(1, 1), ArmorItem.new(3), ArmorItem.new(1),
		ArmorItem.new(2), ArmorItem.new(2), ArmorItem.new(5),
		ArmorItem.new(2), ArmorItem.new(0, 10)
	]

func _get_names() -> Array[Item]: return [
		_item("К. Штаны", "C", "Сделаны из цельного куска кожи", "pants/pants.svg"),
		_item("К. Поножи", "A", "Надежно защищает от попадания стрел", "pants/greaves.svg"),
		_item("К. Ботинки", "C", "Без ботинок по раскаленным поверхностям перемещаться будет тяжеловато", "boots/leather.svg"),
		_item("К. Сапоги", "A", "В них очень приятно давить ползающих гадюк", "boots/iron.svg"),
		_item("К. Куртка", "C", "Прикрывает спину от палящего солнца", "jacket/leather.svg"),
		_item("К. Нагрудник", "A", "Плотная кольчуга хорошо защищает от пробитий", "jacket/iron.svg"),
		_item("Ж. Щит", "R", "Защищает от внезапных ударов с 1% шансом", "artifact/shield.svg"),
		_item("Зуб мудрости", "R", "Усиливает ваше влияние", "artifact/tooth.svg")
	]
