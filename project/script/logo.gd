extends ColorRect



"""
@onready var spawn: Node = $spawn
@onready var pool: Node = $pool
@onready var hud_reseter: Timer = $hud

var hud: EnemyHUD = EnemyHUD.new()

func _enemy(tag: Vector2i) -> String:
	match spawn.lay.tags.from_coords(tag).context.atlas:
		Vector2i(1, 0): return "boss"
		_: return "foe"

func set_enemies_spawn(lay: Node) -> void:
	spawn.set_spawn(lay)
	var type: Dictionary = spawn.select(pool)
	for i in range(0, spawn.places.size()):
		set_enemy(i, spawn.places[i], type)

func setup(lay: Node, casual_mode: bool) -> void:
	hud.set_timer(self)
	if not casual_mode: set_enemies_spawn(lay)

func set_enemy(i: int, tag: Vector2i, type: Dictionary) -> void:
	var enemy: CharacterBody2D = spawn.from_pool(type, pool, _enemy(tag))
	spawn.initiate(enemy, i, tag)
	enemy.view.animation.dead.transport.connect(func(): spawn.dead(enemy))
	hud.setup(enemy)
"""
