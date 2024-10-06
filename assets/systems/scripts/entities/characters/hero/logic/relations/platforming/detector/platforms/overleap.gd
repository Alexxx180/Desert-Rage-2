extends Node

var _platforming: Node

func set_control(overleap: Node2D, platforming: Node) -> void:
	_platforming = platforming
	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _on_ledge_encounter_gap(surface: TileMapLayer) -> void:
	Processors.lazy(_platforming, _platforming.jump.floor_only, surface)

func _on_ledge_encounter_upland(surface: TileMapLayer) -> void:
	Processors.lazy(_platforming, _platforming.jump.determine, surface)
