extends PanelContainer

@onready var caption: Label = $margin/label

func set_text(text: String) -> void:
	caption.text = text
