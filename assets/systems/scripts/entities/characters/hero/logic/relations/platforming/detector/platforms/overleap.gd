extends Node

var _platforming: Node

func set_control(detector: Area2D, platforming: Node) -> void:
	_platforming = platforming
	detector.body_entered.connect(_on_ledge_encounter)

func _on_ledge_encounter(_surface: TileMapLayer) -> void:
	Processors.lazy(_platforming, _platforming.jump.determine)