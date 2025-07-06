extends Node

const TICK: int = 1

@onready var period: Timer = $period
@onready var cooldown: Timer = $cooldown

var recovery: Dictionary = {
	"hp": { "hero": {}, "use": 40, "max": 40 },
	"ap": { "hero": {}, "use": 40, "max": 40 }
}

func recover(hero: CharacterBody2D, category: String) -> void:
	recovery[category].hero[hero.get_instance_id()] = hero
	period.start()

func stop_recover(hero: CharacterBody2D, category: String) -> void:
	recovery[category].hero.erase(hero.get_instance_id())
	if recovery.hp.hero.size() <= 0 and recovery.ap.hero.size() <= 0:
		period.stop()

func recover_cooldown() -> void:
	var hp_use: bool = recovery.hp.use < recovery.hp.max
	if hp_use:
		recovery.hp.use += TICK
		hp_use = recovery.hp.use < recovery.hp.max
	
	var ap_use: bool = recovery.ap.use < recovery.ap.max
	if ap_use:
		recovery.ap.use += TICK
		ap_use = recovery.ap.use < recovery.ap.max
		if not ap_use and not hp_use:
			cooldown.stop()
	elif not hp_use:
		cooldown.stop()

func recover_period() -> void:
	var hp_use: bool = recovery.hp.use > 0
	if hp_use:
		for hero in recovery.hp.hero.values():
			hero.logic.processors.stats.health.refill(1)
			recovery.hp.use -= TICK
			hp_use = recovery.hp.use > 0
			if not hp_use: break
	
	var ap_use: bool = recovery.ap.use > 0
	if ap_use:
		for hero in recovery.ap.hero.values():
			hero.logic.processors.stats.aura.refill(1)
			recovery.ap.use -= TICK
			ap_use = recovery.ap.use > 0
			if not ap_use: break
		if not ap_use and not hp_use:
			period.stop()
	elif not hp_use:
		period.stop()
	
	if recovery.hp.use < recovery.hp.max or recovery.ap.use < recovery.ap.max:
		cooldown.start()
	
	if recovery.hp.hero.size() <= 0 and recovery.ap.hero.size() <= 0:
		period.stop()
