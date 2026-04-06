class_name LevelsPillar extends RefCounted

var dashed: bool = false
var view: Node2D
var whip: Node2D
var pillars: Node2D
var floors: Node
var layers: Lay
var chains: Node# 2D
var levels: Node
var teleport: Node
var caught: bool = false
var target_pos: Vector2
var ledge: Dictionary

func _init(node: Node) -> void: ledge = { "node": node, "offset": 0 }

var rotation: Dictionary = {
	Vector2i(1, 0): 0, Vector2i(-1, 0): 180, 
	Vector2i(0, 1): 90, Vector2i(0, -1): -90 }

func set_ledge(is_chains: bool, BORDERS: float = 8.5) -> void:
	if Def.ic("IS CHAINS: ", is_chains): set_offset(whip, 0)
	else: set_offset(pillars, BORDERS)

func _turn_collision(state: bool) -> void:
	layers.context(state).collide_main()
	dashed = !state

func _selective_dash(pos: Vector2) -> void:
	if chains.hanging:
		whip_catch(Def.ic('WHIP CATCH %s', pos))
	else:
		whip_dash(Def.ic('WHIP DASH %s', pos))

func _perform_dash(pos: Vector2) -> void:
	_turn_collision(false)
	_selective_dash(rotate_whip(pos))

func ledge_is_near(ignore_floor: bool) -> bool:
	for pillar in ledge.node.jump_zone.walls:
		if pillar.is_colliding():
			target_pos = ledge.node.jump_zone.position + pillar.position
			return floors.same_to_hero(target_pos) or ignore_floor
	return false

func is_near(ignore_floor: bool = false) -> bool:
	print("LEDGES CHECK FOR: ", ledge.node.name, " - ZONE: ", ledge.node.jump_zone)
	print("BORDER ZONE: ", not ledge.node.jump_zone.border.is_colliding())
	return not ledge.node.jump_zone.border.is_colliding() and ledge_is_near(ignore_floor)

func dash_on_whip() -> void: _perform_dash(Def.ic("DASH ON WHIP %s", target_pos))
func set_offset(next: Node, offset: float) -> void: ledge.node = next ; ledge.offset = offset
func whip_caught(_execute: TileMapLayer) -> void: caught = true
func whip_left(_execute: TileMapLayer) -> void: caught = false
func whip_dashed() -> void: _turn_collision(true)
func whip_dash(pos: Vector2) -> void: teleport.dash(pos, "whip_dash")
func rotate_whip(pos: Vector2) -> Vector2: return rotate(pos, ledge.offset)

func whip_catch(pos: Vector2) -> void:
	if Def.ic("BUT POS WAS: ", pos).x != 0: return
	teleport.dash(pos, "go")
	view.animation.moves.set_hang("move")
	view.animation.moves.set_hang_move("whip_dash")

func rotate(pos: Vector2, jump_offset: float) -> Vector2:
	view.whip.rotation_degrees = rotation[pillars.dir]
	return pos + jump_offset * pillars.dir
