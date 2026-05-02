extends HBoxContainer

@onready var content: Dictionary = {
	"ambient": $content/ambient,
	"heating": $content/heating,
	"rampage": $content/rampage
}

var i: int
var event: int

func set_options(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context, self)
