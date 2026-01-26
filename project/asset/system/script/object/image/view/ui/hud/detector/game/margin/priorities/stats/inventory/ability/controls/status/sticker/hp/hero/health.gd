extends MarginContainer

@onready var damage: PanelContainer = $damage
@onready var status: HBoxContainer = $damage/status
@onready var points: HBoxContainer = $damage/status/margin/points
@onready var back: TextureRect = $damage/back

const MAX: float = 0.95

func change(hp: Node) -> void:
	show()
	points.change(hp)
	var value: float = MAX * hp.points / hp.maximum
	back.texture.fill_to.y = value
	# back.visible = value > 
