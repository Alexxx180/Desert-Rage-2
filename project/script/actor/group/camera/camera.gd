extends Camera2D

func _ready() -> void: get_parent().set_script(Def.root)

@export_flags_2d_physics var chests: PackedInt32Array = [0, 0]
@export_flags_2d_physics var pages: PackedInt32Array = [0, 0]
@export_flags_2d_physics var books: PackedInt32Array = [0, 0]
@export_flags_3d_navigation var enemy_navigation: PackedInt32Array = [  ## AI strategy. Move | C = to, F = from
	0, 0]
@export var enemy_proportion: PackedFloat32Array = []
@export_flags_3d_physics var enemy: int
@export_flags_3d_render var mode: int


@onready var cooldown: Timer = $cooldown
@onready var stats: RecoveryStats = RecoveryStats.new()

func recover(hero: CharacterBody2D, type: String) -> void:
	stats.start_recover(type, hero)
	start()

func stop_recover(hero: CharacterBody2D, type: String) -> void:
	stats.stop_recover(type, hero)
	if stats.no_one(): stop()

func stop_if(act: String, ap_act: String, ap: Callable) -> bool:
	var stopped: bool = not stats.get(act).call()
	if stats.get(ap_act).call("ap"):
		stopped = stopped and not ap.call()
	return stopped

func recover_cooldown() -> void:
	if stop_if("hp_fill", "middle", stats.ap_fill):
		cooldown.stop()

func stop_period() -> void:
	if (stop_if("hp_recover", "enough", stats.ap_recover) or
		stats.no_one()): stop()

func recover_period() -> void:
	stop_period()
	if stats.can_fill(): cooldown.start()
	
