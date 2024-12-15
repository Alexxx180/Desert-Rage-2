extends VBoxContainer

@export var help: HelpHint

func _ready() -> void:
	$head/margin/caption.text = help.head
	$body/margin/caption.text = help.body
