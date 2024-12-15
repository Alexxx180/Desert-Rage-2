extends VisibleOnScreenNotifier2D

func _ready() -> void:
	var asset: Node2D = get_parent()
	screen_entered.connect(asset.show)
	screen_exited.connect(asset.hide)
	asset.visible = false
