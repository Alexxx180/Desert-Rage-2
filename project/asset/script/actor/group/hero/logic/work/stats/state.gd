class_name HeroState extends BitField

enum { STANDING }

var is_standing: get = get_standing, set = standing_to

func get_standing() -> bool: return get_value(STANDING)
func standing_to(next: bool) -> void: set_value(STANDING, next)
