extends VBoxContainer

@onready var hints: VBoxContainer = $hints
@onready var topic: Control = $topic
@onready var status: VBoxContainer = $status

var control: bool:
	set(value):
		status.sticker.hp.control = value
		topic.status.space.title.enemies.enemy.margin.visible = value
		
