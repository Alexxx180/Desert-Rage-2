extends VBoxContainer

@onready var hp: HBoxContainer = $hp

var _markers: HFlowContainer = null
var markers: HFlowContainer:
	get:
		if _markers == null: # TODO SET MARKERS FREE FROM LINKING
			_markers = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/status/markers/markers.tscn").instantiate()
			add_child(_markers)
		return _markers
