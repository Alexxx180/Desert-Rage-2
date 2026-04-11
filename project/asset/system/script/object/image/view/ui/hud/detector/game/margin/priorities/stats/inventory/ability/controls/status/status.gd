extends VBoxContainer

@onready var points: HBoxContainer = $points

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get: return Works.upload_at(self, _hp, "hp", Defaults.now.hp, "hp")

var _markers: HFlowContainer = null
var markers: HFlowContainer:
	get: return Works.upload(self, _markers, Defaults.now.items, "markers") # TODO SET MARKERS FREE FROM LINKING
