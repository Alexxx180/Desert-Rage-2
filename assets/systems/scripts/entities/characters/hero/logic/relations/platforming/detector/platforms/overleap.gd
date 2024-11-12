extends Node

var _input: Node

func set_control(overleap: Node2D, platforming: Node) -> void:
	var map: Node2D = overleap.get_node("../../../../../../../..") #/../map
	_input = platforming.input
	_input.gap = map.get_node("gap")
	_input.upland = map.get_node("upland")
	_input.floors.jump.connect(platforming.jump.floor_only)
	_input.ledges.jump.connect(platforming.jump.determine)

	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	_input.floors.available = true

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	#print("UPLAND")
	_input.ledges.available = true
