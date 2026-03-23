extends PanelContainer

@onready var tabs: HBoxContainer = get_parent()

func transparent() -> void: tabs.modulate = Color.TRANSPARENT
func usual() -> void: tabs.modulate = Color.WHITE

func _ready() -> void:
	mouse_entered.connect(transparent)
	mouse_exited.connect(usual)
