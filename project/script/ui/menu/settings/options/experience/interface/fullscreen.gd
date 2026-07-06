extends BinaryChoice

func _default_caption() -> Array: return ["SWND", "SFSN"]

func _view() -> Variant: return self

func _ready() -> void: change_choice(bool(DisplayServer.window_get_mode()))

func set_fullscreen() -> void: DisplayServer.window_set_mode(int(_choice))

func toggle() -> void:
	change_choice()
	set_fullscreen()
