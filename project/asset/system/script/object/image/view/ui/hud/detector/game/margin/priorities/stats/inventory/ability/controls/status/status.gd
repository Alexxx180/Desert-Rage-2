extends VBoxContainer

@onready var points: HBoxContainer = $points

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get:
		if _hp == null:
			var health: PackedScene = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/status/points/health.tscn")
			var p: Control = $hp
			p.add_sibling(health.instantiate())
			remove_child(p)
		return _hp

var _markers: HFlowContainer = null
var markers: HFlowContainer:
	get:
		if _markers == null: # TODO SET MARKERS FREE FROM LINKING
			_markers = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/status/markers/markers.tscn").instantiate()
			add_child(_markers)
		return _markers
