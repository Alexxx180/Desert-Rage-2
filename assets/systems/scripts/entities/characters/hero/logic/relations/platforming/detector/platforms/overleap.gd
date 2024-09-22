extends Node

var _platforming: Node

func set_control(detector: Area2D, platforming: Node) -> void:
	_platforming = platforming
	detector.body_entered.connect(_platforming.on_ledge_encounter)

func _on_ledge_encounter(_surface: TileMap) -> void:
	Processors.lazy(_platforming, _platforming.jump.determine)
