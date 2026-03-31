extends VBoxContainer

@onready var topic: Control = $topic
@onready var status: VBoxContainer = $status

var _hints: VBoxContainer = null
var hints: VBoxContainer:
	get:
		if _hints == null:
			_hints = load("res://asset/system/scene/object/canvas/ui/hud/detector/game/menu/ability/controls/hints/hints.tscn").instantiate()
			status.add_sibling(_hints)
		return _hints

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
