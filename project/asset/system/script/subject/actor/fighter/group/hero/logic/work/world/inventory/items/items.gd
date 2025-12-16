extends RefCounted

class_name GameItems

var keys: KeyTypeItems = KeyTypeItems.new()
var uses: UseTypeItems = UseTypeItems.new()
var armor: ArmorTypeItems = ArmorTypeItems.new()
var weapon: WeaponTypeItems = WeaponTypeItems.new()
var equip: EquipTypeItems = EquipTypeItems.new()
var crafting: CraftingItems = CraftingItems.new(self)

func get_item(no: int) -> Dictionary:
	if no < 0: return Defaults.DICT

	print("actual number: ", no)
	var j: int = 0 # var type
	for i in ["keys", "uses", "armor", "weapon", "equip"]:
		var type = get(i)
		print("type: ", i)
		if no < (type.size + j):
			print("category type: ", j)#, type.get_item(j).item.name)
			return type.get_item(no - j)
		j += type.size 

	print("got untypical id number: ", no)
	return Defaults.DICT
