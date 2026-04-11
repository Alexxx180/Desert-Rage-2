extends VBoxContainer

@onready var topic: Control = $topic
@onready var status: VBoxContainer = $status

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get: return Works.upload_at(self, status, _hints, Defaults.now.hints % "hints", "hints")

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
