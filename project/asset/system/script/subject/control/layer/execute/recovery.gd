extends Node

@onready var period: Timer = $period
@onready var cooldown: Timer = $cooldown
@onready var stats: Node = $stats

func recover(hero: CharacterBody2D, type: String) -> void:
	stats.start_recover(type, hero)
	period.start()

func stop_recover(hero: CharacterBody2D, type: String) -> void:
	stats.stop_recover(type, hero)
	if stats.no_one(): period.stop()

func stop_if(act: String, ap_act: String, ap: Callable) -> bool:
	var stop: bool = not stats.get(act).call()
	if stats.get(ap_act).call("ap"):
		stop = stop and not ap.call()
	return stop

func recover_cooldown() -> void:
	if stop_if("hp_fill", "middle", stats.ap_fill):
		cooldown.stop()

func stop_period() -> void:
	if (stop_if("hp_recover", "enough", stats.ap_recover) or
		stats.no_one()): period.stop()

func recover_period() -> void:
	stop_period()
	if stats.can_fill(): cooldown.start()
