extends VBoxContainer

@onready var preview: HBoxContainer = $hints/space/preview
@onready var topic: HFlowContainer = $topic
@onready var status: VBoxContainer = $status

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
