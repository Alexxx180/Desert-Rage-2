extends PanelContainer

@onready var lamp: Control = $lamp
@onready var back: TextureRect = $back
@onready var margin: MarginContainer = $margin
@onready var timer: Timer = $timer

var interrogating: bool = false

func _ready() -> void: timer.timeout.connect(set_disabled_tint)

func set_tint(a: int) -> void:
	lamp.modulate = Color8(255, 255, 255, a)
	back.modulate = Color8(255, 255, 255, a)
	margin.modulate = Color8(255, 255, 255, a)

func set_disabled_tint() -> void:
	if not interrogating:
		set_tint(255)

func show_start() -> void:
	if timer.is_stopped():
		timer.start()
		set_tint(60)
