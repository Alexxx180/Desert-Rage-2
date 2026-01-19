extends TypeItems

class_name WeaponTypeItems

func _icon(path: String) -> String: return "weapon/" + path
func _pow(value: int) -> IWeapon: return IWeapon.new(value)

func _get_effect() -> Array[Dictionary]: return [
		_item("IKD", "WM", "melee/knuckle-duster", _pow(3).eqw([0, 1])),
		_item("IKW", "WM", "melee/knife", _pow(2)),
		_item("ISW", "WM", "melee/sword", _pow(4)),
		_item("IST", "WM", "melee/toy-sword", _pow(7)),
		_item("ICS", "WF", "firearm/schofield45-colt", _pow(5)),
		_item("IPT", "WF", "firearm/pacifist-colt", _pow(7)),
		_item("ISH", "WF", "firearm/shotgun", _pow(9)),
		_item("IBM", "WR", "boomerang", _pow(3)),
		_item("IBS", "WM", "melee/shoe", _pow(50)),
	]
