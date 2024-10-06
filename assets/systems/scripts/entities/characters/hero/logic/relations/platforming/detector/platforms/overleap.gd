extends Node

var _platforming: Node
var _overleap: Node

func set_control(overleap: Node2D, platforming: Node) -> void:
	_platforming = platforming
	var input: Node = _platforming.input

	input.floors.jump.connect(_platforming.jump.floor_only)
	input.ledges.jump.connect(_platforming.jump.determine)

	_overleap = overleap
	overleap.gap.body_entered.connect(_on_ledge_encounter_gap) #overleap.gap.body_exited.connect(_on_ledge_exit_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)
	Processors.turn(_platforming, true)

func _on_ledge_encounter_gap(surface: TileMapLayer) -> void:
	#print("ENCOUNTER")
	#if (_overleap.gap.position == Vector2.ZERO):
	#	print("POS X: ", _overleap.gap.position)
	#	return
	#print("POS V: ", _overleap.gap.position)
	#_overleap.gap.position = Vector2.ZERO
	_platforming.input.surface = surface
	_platforming.input.floors.available = true

func _on_ledge_exit_gap(surface: TileMapLayer) -> void:
	#_overleap.gap.position = Vector2.ZERO
	print("YO!")
	_platforming.input.surface = surface
	_platforming.input.floors.available = true
	

func _on_ledge_encounter_upland(surface: TileMapLayer) -> void:
	#if (_overleap.position == Vector2.ZERO): return
	#_overleap.position = Vector2.ZERO
	_platforming.input.surface = surface
	_platforming.input.ledges.available = true
