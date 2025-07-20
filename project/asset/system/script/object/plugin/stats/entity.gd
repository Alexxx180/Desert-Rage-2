extends Resource

class_name EntityStats

const STEP: int = 1000

@export_group("Survival")
@export_range(1, 500, 1, "HP") var health: float = 100
@export_range(1, 500, 1, "AP") var aura: float = 20

@export_group("Fight stats")
@export_range(1, 255, 1, "Damage") var power: float = 5
@export_range(1, 255, 1, "Skills") var influence: float = 5
@export_range(1, 255, 1, "Defence") var vitality: float = 5
@export_range(1, 255, 1, "No fight") var reaction: float = 5

@export_group("World metrics")
@export_range(10, 64, 1, "Box force") var push: int = 2
@export_range(10, 255, 1, "Overall speed") var run: int = 33 # 20

var _mach: int = 1
var speed: float = 0
var force: float = 0

func update_stats():
	speed = _mach * STEP * run
	force = _mach * STEP * push

func accelerate(mach: int) -> void:
	_mach = mach
	update_stats()

func decide_travel(weight: int, motion: Vector2) -> Vector2:
	return motion * speed if weight == 0 else motion * force / weight
