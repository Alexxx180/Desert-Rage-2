extends Resource

class_name SplitNavigation

@export_group("Survival")
@export var main: String = "drag_up"
@export var events: Array[ActionButtonGroup] = [
	ActionButtonGroup.new()
]


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
