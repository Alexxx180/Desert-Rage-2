extends PanelContainer

func transparent() -> void: modulate = Color.TRANSPARENT
func usual() -> void: modulate = Color.WHITE

func _ready() -> void:
	mouse_entered.connect(transparent)
	mouse_exited.connect(usual)
