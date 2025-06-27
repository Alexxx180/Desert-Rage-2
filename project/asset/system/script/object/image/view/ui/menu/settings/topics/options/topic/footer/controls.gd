extends TopicFooter

@onready var controls: HBoxContainer = $margin/controls
@onready var caption: Label = $margin/caption

func set_controls(focus: bool) -> void:
	controls.visible = !focus
	caption.visible = focus
