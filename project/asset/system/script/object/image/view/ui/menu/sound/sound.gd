extends CanvasLayer

func _ready() -> void:
	$processor.setup.set_soundtrack($detector/margin/soundtrack/dropdown)
