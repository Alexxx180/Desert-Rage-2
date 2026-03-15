extends PanelContainer

@onready var health: ProgressBar = $hp/health
@onready var contested: ProgressBar = $hp/contested
@onready var caption: PanelContainer = $content/margin/title/caption # TODO fix caption and interrogate for enemy
@onready var modulator: Node = $modulator
@onready var margin: MarginContainer = $margin
@onready var damage: PanelContainer = $content/margin/title/caption/damage
@onready var hits: VBoxContainer = $content/hits # margin/contents/
@onready var back: TextureRect = damage.get_node("back") # @onready var interrogate: Label = $margin/contents/interrogate
@onready var damages: HBoxContainer = damage.get_node("margin/damage")

func _ready() -> void: caption.health = health
func appear() -> void: modulator.appear(self)
func disappear() -> void: modulator.disappear(self)

func set_hp(hp: Node) -> void:
	damages.health.text = str(int(hp.contested))
	damages.value.text = str(int(hp.contested - hp.points))
	back.set_value(hp)
