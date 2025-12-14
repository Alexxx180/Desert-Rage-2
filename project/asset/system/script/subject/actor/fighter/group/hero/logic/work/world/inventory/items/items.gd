extends RefCounted

class_name GameItems

var keys: KeyTypeItems = KeyTypeItems.new()
var uses: UseTypeItems = UseTypeItems.new()
var armor: ArmorTypeItems = ArmorTypeItems.new()
var weapon: WeaponTypeItems = WeaponTypeItems.new()
var crafting: CraftingItems = CraftingItems.new(self)

func get_item(no: int) -> Variant:
	if no < 0: return null

	var j: int = 0
	for i in ["keys", "uses", "armor", "weapon", "equip"]:
		var type = get(i)
		if no < (type.size + j):
			return type.get_item(no - j)
		j += type.size 

	return null

