extends Node

signal teleport(position: Vector2)
signal dash(position: Vector2)
signal set_movement(is_floor: bool)

@onready var floors: Node = $floors

var stable: bool = true
var unstable: bool:
	get: return not stable
var _deploy: DeploymentRaycast

func set_stable(is_floor: bool) -> void:
	if is_floor != stable:
		set_movement.emit(is_floor)
		stable = is_floor

func set_deploy(next) -> void:
	_deploy = next #; print("SET deploy")
	_deploy.walls.floors = floors

func get_ground() -> Vector2:
	return floors.hero.position + _deploy.walls.target

func set_box(box: CharacterBody2D) -> void:
	floors.hero.to.act.teleport.platform.set_box(box)

func deploy() -> void:
	if _deploy.can_deploy():
		jump(_deploy.walls.target_ground, true, dash)

func jump(next: Vector2, to_floor: bool = false, move = teleport) -> void:
	set_stable(to_floor)
	print("WAIT WHAT")
	move.emit(next)
