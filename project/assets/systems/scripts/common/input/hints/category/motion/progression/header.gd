extends PanelContainer

@export var caption: String = ""

func _ready() -> void:
	$margin/caption.text = caption
