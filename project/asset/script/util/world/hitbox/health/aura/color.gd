class_name GameStatuses extends RefCounted

enum { BURN }

var timing: PackedByteArray = [0, 1, 0]

func set_status(hero: int, type: int) -> void:
	var tween: Tween = HUD.aura_time.create_tween()
	match type:
		BURN: tween.tween_method(func(): burns(hero), timing[hero], 0)

func burns(hero: int) -> void:
	if points.alive: _apply_damage(amount)
	HUD.level.aura.affect_aura(hero, -1)
	damage[SUMMARY] = max(damage[SUMMARY] - period, 0)
	if damage[SUMMARY] == 0:
		HUD.aura_time.stop()
