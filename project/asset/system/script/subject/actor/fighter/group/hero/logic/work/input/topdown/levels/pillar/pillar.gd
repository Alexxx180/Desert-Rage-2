extends Node

const BORDERS: float = 8.5

@onready var ledges: Node = $ledges
@onready var env: Node = $env

var dashed: bool = false

func whip_dashed() -> void: _turn_collision(true)

func set_ledge(is_chains: bool) -> void:
	print("IS CHAINS: ", is_chains)
	if is_chains: ledges.set_offset(env.whip, 0)
	else: ledges.set_offset(env.pillars, BORDERS)

func _turn_collision(state: bool) -> void:
	env.layers.context(state).collide_main()
	dashed = !state

func _selective_dash(pos: Vector2) -> void:
	if env.chains.above:
		print("WHIP CATCH")
		env.whip_catch(pos)
	else:
		print("WHIP DASH")
		env.whip_dash(pos)

func _perform_dash(pos: Vector2) -> void:
	_turn_collision(false)
	_selective_dash(ledges.rotate_whip(pos))

func dash_on_whip() -> void:
	print("DASH ON WHIP")
	_perform_dash(ledges.target_pos)
