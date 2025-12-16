extends TypeItems

class_name EquipTypeItems

func _icon(path: String) -> String: return "armor/equip/" + path

func _get_effect() -> Array:
	var damage: String = "damage_increase"; var rate: String = "fire_rate"
	return [
		EquipItem.new(rate, 5), EquipItem.new("burn_time", 25),
		EquipItem.new(damage, 5), EquipItem.new("spread_decrease", 10),
		EquipItem.new(damage, 15), EquipItem.new("range", 5),
		EquipItem.new(rate, 5), EquipItem.new("skip_cost", 10)
	]

func _get_names() -> Array[Item]: return [
		_item("Масло", "+5% скорость атак", "Смазывая клинки маслом, можно получить интересный эффект.", "butter.svg"),
		_item("Огненное масло", "+25% времени ожога", "Это раскаленное масло отличный выбор для гриля.", "fire-butter.svg", Item.i(Item.A_DOTE)),
		_item("Точ. Камень", "+5% урон", "Главный инструмент на кухне - это нож и его надо хорошо наточить перед использованием.", "fasten.svg", Item.i(Item.A_COUGH)),
		_item("Помпа", "-10% рассеивание", "Делает из неотесанного дробовика уточненный винчестер", "pump.svg"),
		_item("М. Наконечник", "+15% урон", "Похоже, что для монстров игры закончились", "metal-end.svg"),
		_item("М. Прицел", "+5% дальность", "Через него хорошо видно, что кто-то не помыл конечности перед трапезой", "target.svg"),
		_item("Очиститель", "+5% скорость атак", "Вычищает всю грязь и налет внутри и снаружи орудий", "cleaner.svg"),
		_item("Доп. Обойма", "-10% расход ресурса", "Будь раньше у меня такая оснастка, я может и не расставался бы с пушками", "magazine.svg")
	]
