extends ProgressBar

@onready var health: ProgressBar = $health
@onready var contested: ProgressBar = self
@onready var caption: PanelContainer = $text # TODO fix caption and interrogate for enemy
@onready var modulator: Node = $modulator
@onready var damage: Label = caption.get_node("damage")
@onready var hits: HBoxContainer = get_node("../margin/status/hits") #$content/hits
@onready var back: TextureRect = damage.get_node("back") # @onready var interrogate: Label = $margin/contents/interrogate
@onready var damages: HBoxContainer = damage.get_node("margin/damage")

@onready var health_back: StyleBoxFlat = health.get("theme_override_styles/background")

func _ready() -> void: caption.health = health
func appear() -> void: modulator.appear(self)
func disappear() -> void: modulator.disappear(self)

func animate() -> void:
	health_back.content_margin_bottom = 0 # TODO TWEEN VALUE HERE
	damage.text = "ONA! - BAM!"

func set_hp(hp: Node) -> void:
	damages.health.text = str(int(hp.contested))
	damages.value.text = str(int(hp.contested - hp.points))
	back.set_value(hp)
