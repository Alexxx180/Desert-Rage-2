extends Node

enum { BORDER = 0, TICK = 1 }

var recovery: Dictionary = {
	"hp": { "hero": {}, "use": 40, "max": 40 },
	"ap": { "hero": {}, "use": 40, "max": 40 }
}
# TODOT REC
func start_recover(type: String, hero: CharacterBody2D) -> void:
	recovery[type].hero[hero.get_instance_id()] = hero

func stop_recover(type: String, hero: CharacterBody2D) -> void:
	recovery[type].hero.erase(hero.get_instance_id())

func fill(type: String) -> bool:
	_stat(type).use += TICK
	return middle(type)

func empty(type: String) -> bool:
	var stat: Dictionary = _stat(type)
	stat.use = max(BORDER, stat.use - TICK)
	return not enough(type)

func recover(bar: String, type: String) -> bool:
	for hero in _stat(type).hero.values():
		hero.to.stats.get(bar).refill(TICK)
		if empty(type): return false
	return true

func hp_recover() -> bool: return enough("hp") and recover("health", "hp")
func hp_fill() -> bool: return middle("hp") and fill("hp")
func ap_fill() -> bool: return fill("ap")
func ap_recover() -> bool: return recover("aura", "ap")
func can_fill() -> bool: return middle("hp") or middle("ap")

func _stat(type: String) -> Dictionary: return recovery.get(type)

func enough(type: String) -> bool: return _stat(type).use != BORDER
func middle(type: String) -> bool: return _stat(type).use < _stat(type).max
func nobody(type: String) -> bool: return _stat(type).hero.size() == 0

func no_one() -> bool: return nobody("hp") and nobody("ap")
