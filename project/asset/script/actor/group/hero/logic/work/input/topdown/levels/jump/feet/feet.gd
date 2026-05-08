class_name JumpDeployment extends Node

signal teleport(position: Vector2)
signal dash(position: Vector2)
signal set_movement(is_floor: bool)

var entity: CharacterBody2D
var stable: bool = true
var velo: VeloHero
var F: int: get = get_floor

func _init() -> void: entity = HUD.ENTITY
func get_floor() -> int: return velo.extract(get_state())

func set_stable(is_floor: bool) -> void:
	if is_floor != stable:
		set_movement.emit(is_floor)
		stable = is_floor

func set_deploy(next) -> void:
	velo.deploy = next #; print("SET deploy")
	velo.deploy.walls.floors = self

func deploy() -> void:
	if velo.deploy.can_deploy():
		jump(velo.deploy.walls.target_ground, true, dash)

func jump(next: Vector2, to_floor: bool = false, move = teleport) -> void:
	set_stable(to_floor)
	move.emit(Def.ic("WAIT WHAT: %s", next))

func get_state() -> Variant:
	if entity == HUD.ENTITY:
		velo.remember_pos()
		return Def.ic("ENTITY is LEDGE %s", velo.state)
	return Def.ic("ENTITY is BOX %s", entity)

func same(sub: Variant) -> bool:
	var f: int = velo.extract(sub)
	return Def.ics("%s | HERO F: %d and BOX f: %d, but height: ", [f == F, F, f, sub.height])

func same_to_hero(ground: Vector2) -> bool:
	var _s: Variant = get_state()
	var pos: Vector2 = _s.ledge if "ledge" in _s else _s.position
	return same({ "position": Def.ic("SEE A FLOOR: %s", pos + ground), "height": 0 }) # hero
