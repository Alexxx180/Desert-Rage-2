extends RefCounted

class_name GameItems

enum { ITEM = 0, CRAFT = 1, EQUIP = 2 }

var keys: KeyTypeItems = KeyTypeItems.new()
var uses: UseTypeItems = UseTypeItems.new()
var armor: ArmorTypeItems = ArmorTypeItems.new()
var weapon: WeaponTypeItems = WeaponTypeItems.new()
var equip: EquipTypeItems = EquipTypeItems.new()
var crafting: CraftingItems = CraftingItems.new(self)

func is_consumable(id: int) -> bool:
	return keys.in_items(id) or uses.in_items(id)

func is_equipable(id: int) -> bool:
	return weapon.in_items(id) or armor.in_items(id)

func craft(id: int) -> int:
	if equip.in_items(id): return EQUIP
	if crafting.in_items(id): return CRAFT
	return ITEM

func items() -> Array[String]: return ["keys", "uses", "armor", "weapon", "equip"]
func _init() -> void:
	var j: int = 0
	for i in items():
		var type = get(i)
		type.origin = j
		j += type.size

func get_item(no: int) -> Dictionary:
	if no < 0: return Defaults.DICT

	print("actual number: ", no)
	var j: int = 0 # var type
	for i in items():
		var type = get(i) ; print("type: ", i)
		if no < (type.size + j):
			print("category type: ", j); return type.get_item(no - j)#, type.get_item(j).item.name)
		j += type.size

	print("got untypical id number: ", no); return Defaults.DICT
