extends TypeItems

class_name KeyTypeItems

func _icon(path: String) -> String: return "items/" + path

func k(effect: String) -> IKey: return IKey.new(effect)

func _get_effect() -> Array[Dictionary]: return [
		_item("IJ", "KL", "jar/bottle", k("store_water")),
		_item("ID", "PX", "jar/antidote", k("no_poison"), i(A_DOTE)),
		_item("IC", "CX", "jar/anti-cough", k("no_cough"), i(A_COUGH)),
		_item("IS", "CP", "craft/saksaul", k("distract")),
		_item("IG", "OL", "keys/gold", k("open_lock")),
		_items("IPK", "NA", "NA", "keys/secret", k("open_mystic"))
	]
