class_name Fighting extends RefCounted

func close_damage(hero: int) -> void:
	for foe in HUD.level.entity[hero].enemy:
		HUD.level.aura.affect_aura(foe, -Def.pow[hero][POWER])
