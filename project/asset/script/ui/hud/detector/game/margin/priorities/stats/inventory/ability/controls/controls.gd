extends VBoxContainer

@onready var topic: Control = $topic
@onready var status: HBoxContainer = $status

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get: return Works.upload_at(status, _hp, "hp", Defaults.now.hp, "hp")

var _markers: HFlowContainer = null
var markers: HFlowContainer:
	get: return Works.upload(self, _markers, Defaults.now.items, "markers") # TODO SET MARKERS FREE FROM LINKING


var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return Works.upload_at(self, status, _hints, Defaults.now.hints % "hints", "hints")

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
