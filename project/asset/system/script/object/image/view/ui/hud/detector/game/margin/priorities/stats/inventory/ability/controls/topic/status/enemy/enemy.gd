extends PanelContainer

@onready var health: ProgressBar = $hp/health
@onready var contested: ProgressBar = $hp/contested
@onready var caption: PanelContainer = $caption # TODO fix caption and interrogate for enemy
@onready var back: TextureRect = $margin/contents/damage/back
# @onready var interrogate: Label = $margin/contents/interrogate
@onready var damage = $margin/contents/damage
@onready var hits: VBoxContainer = $margin/contents/hits
@onready var damages: HBoxContainer = damage.get_node("margin/damage")

func set_hp(hp: Node) -> void:
	damages.health.text = str(int(hp.contested))
	damages.value.text = str(int(hp.contested - hp.points))
	#if (back.texture.fill_from.y < 0.99):
	const MAX: float = 0.95
	var value: float = MAX - MAX * hp.points / hp.maximum
	back.texture.fill_from.y = value
	back.visible = value < MAX
