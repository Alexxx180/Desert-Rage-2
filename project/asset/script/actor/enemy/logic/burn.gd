extends Timer

signal hit(damage: int)

@export var period: int = 1

var summary_damage: int = 0

func _ready() -> void: timeout.connect(burns)

func dead() -> void:
	summary_damage = 0
	stop()

func contact(damage: int) -> void:
	summary_damage += damage
	if summary_damage > 0 and is_stopped(): start()

func burns() -> void:
	summary_damage = max(summary_damage - period, 0)
	hit.emit(period)
	if summary_damage == 0: stop()
