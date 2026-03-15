extends PanelContainer

@onready var lamp: Control = $lamp
@onready var back: TextureRect = $back
@onready var margin: MarginContainer = $margin
@onready var enemy: Label = $margin/text
@onready var timer: Timer = $timer
@onready var hiding: Timer = $hiding

var combos: Node
var health: ProgressBar
var interrogating: bool = false
var _title: String

func set_title(title: String) -> void:
	_title = title
	enemy.text = title

func _ready() -> void:
	timer.timeout.connect(set_disabled_tint)

func set_tint(a: int) -> void:
	lamp.modulate = Color8(255, 255, 255, a) # back.modulate = Color8(255, 255, 255, a)
	margin.modulate = Color8(255, 255, 255, a)

func set_disabled_tint() -> void:
	if not interrogating:
		set_tint(255)
		back.visible = true
		# if combo.fixate_card(health.value, _title): return
		hiding.start()

func show_start() -> void:
	# combo.has_card TODO FIXME add to condition with and
	if timer.is_stopped() and hiding.is_stopped():
		timer.start()
		set_tint(60)
		back.visible = false
