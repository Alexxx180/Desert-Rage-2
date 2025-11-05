extends HBoxContainer

const MAX: float = 0.95
#@onready var slots: HBoxContainer = $ap/margin/combo/slots
#@onready var status: MarginContainer = $ap/margin/combo/status
#@onready var status_caption: Label = status.get_node("caption")
@onready var health: Label = $health/status/margin/hp/health
@onready var damage: Label = $health/status/margin/hp/damage

@onready var status: MarginContainer = $health/status/margin
@onready var back: TextureRect = $health/status/back
@onready var timer: Timer = $timer

func _ready() -> void:
	timer.timeout.connect(hide_status)

func hide_status() -> void:
	status.hide()
	back.hide()

func set_hp(hp: Node) -> void:
	status.show()
	
	health.text = str(int(hp.contested))
	damage.text = "-" + str(int(hp.contested - hp.points))
	var value: float = MAX * hp.points / hp.maximum
	back.texture.fill_to.y = value
	back.visible = value > 0
	
	timer.start()
