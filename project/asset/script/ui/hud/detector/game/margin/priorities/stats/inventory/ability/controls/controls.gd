extends VBoxContainer

@onready var topic: Control = $topic
@onready var status: HBoxContainer = $status

var _hp: HBoxContainer = null
var hp: HBoxContainer:
	get: return Works.upload_at(status, _hp, "hp", Def.hp, "hp")

var markers: HFlowContainer:
	get: return Works.uploads(self, Def.items, "markers") # TODO SET MARKERS FREE FROM LINKING

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return Works.upload_at(self, status, _hints, Def.hints % "hints", "hints")

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
