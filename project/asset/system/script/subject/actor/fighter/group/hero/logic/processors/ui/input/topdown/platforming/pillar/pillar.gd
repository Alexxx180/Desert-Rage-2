extends Node

const BORDERS: float = 17.0

@onready var dash: Node = $dash

var hero: CharacterBody2D:
	set(value):
		dash.hero = value
		dash.ledge = dash.hero.logic.see.levels.pillar

var chains: Node2D:
	get: return dash.hero.logic.see.levels.chains.whip
var dashed: bool = false

func whip_dashed() -> void: _turn_collision(true)

func set_ledge(is_chains: bool) -> void:
	if is_chains: dash.set_ledge_offset(chains, 0)
	else: dash.set_ledge_offset(dash.walls, BORDERS / 2)

func _turn_collision(state: bool) -> void:
	hero.logic.work.world.layers.context(state).collide_main()
	dashed = !state

func _selective_dash(input: Node, pos: Vector2) -> void:
	if input.platforming.chains.above:
		dash.whip_catch(input, pos)
	else:
		dash.whip_strike(input, pos)

func _perform_dash(pos: Vector2) -> void:
	_turn_collision(false)
	_selective_dash(dash.hero.logic.work.ui.input, dash.rotate_whip(pos))

func dash_on_whip() -> void:
	_perform_dash(dash.target_pos)
